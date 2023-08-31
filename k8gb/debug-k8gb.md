kubectl create deploy gotest --image=quay.io/centos/centos:stream9 -- tail -f /dev/null
kubectl set sa deploy gotest k8gb
kubectl exec -ti deploy/gotest bash
dnf install -y golang vim git patch
mkdir -p ~/go/src/github.com/k8gb.io
export GOPATH=~/go
cd ~/go/src/github.com/k8gb.io && git clone https://github.com/k8gb-io/k8gb && cd k8gb
go build -o bin/k8gb main.go
export POD_NAMESPACE="infra"
export OPERATOR_NAME="k8gb"
export CLUSTER_GEO_TAG="develop"
export EXT_GSLB_CLUSTERS_GEO_TAGS="staging,shared,production"
export EDGE_DNS_ZONE=quid.com
export EDGE_DNS_SERVERS=8.8.8.8,8.8.4.4,1.1.1.1
export DNS_ZONE=gslb.quid.com
export RECONCILE_REQUEUE_SECONDS="30"
export EXTDNS_ENABLED="true"
export COREDNS_EXPOSED="true"
export LOG_FORMAT="simple"
export LOG_LEVEL="debug"
export NO_COLOR="true"
export SPLIT_BRAIN_CHECK="false"
export METRICS_ADDRESS=0.0.0.0:8080

bin/k8gb
