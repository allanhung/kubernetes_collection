kubectl create deploy gotest --image=quay.io/centos/centos:stream9 -- tail -f /dev/null
kubectl set sa deploy gotest k8gb
kubectl exec -ti deploy/gotest bash
dnf install -y golang vim git patch
mkdir -p ~/go/src/github.com/k8gb.io
export GOPATH=~/go
cd ~/go/src/github.com/k8gb.io && git clone https://github.com/k8gb-io/coredns-crd-plugin && cd coredns-crd-plugin/
go build cmd/coredns.go
mkdir -p /etc/coredns
cat > /etc/coredns/Corefile << EOF
gslb.quid.com:5353 {
    errors
    health
    ready
    prometheus 0.0.0.0:9153
    forward . /etc/resolv.conf
    k8s_crd {
        filter k8gb.absa.oss/dnstype=local
        negttl 300
        loadbalance weight
        servicelabel app.kubernetes.io/name=coredns
    }
}
EOF
./coredns -conf /etc/coredns/Corefile
