kubectl create deploy gotest --image=quay.io/centos/centos:stream9 -- tail -f /dev/null
kubectl set sa deploy gotest k8gb
kubectl exec -ti deploy/gotest bash
dnf install -y golang vim git patch
mkdir -p ~/go/src/github.com/kubernetes-sigs
export GOPATH=~/go
cd ~/go/src/github.com/kubernetes-sigs && git clone https://github.com/kubernetes-sigs/external-dns && cd external-dns/
make build
export DNSIMPLE_OAUTH=X7cwvkeRPz9sYkz2IHWc1UnfKtP0fYON
export DNSENV=develop
build/external-dns --provider=dnsimple --source=crd --domain-filter=quid.com --policy=sync --managed-record-types=A --managed-record-types=CNAME --managed-record-types=NS --annotation-filter=k8gb.absa.oss/dnstype=extdns --txt-owner-id=k8gb-${DNSENV} --once --dry-run --log-level=debug
