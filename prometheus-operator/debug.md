### create prometheus server pod for debug
```bash
cat << EOF | kubectl -n infra apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: promdebug
  name: promdebug
spec:
  containers:
  - args:
    - tail
    - -f
    - /dev/null
    env:
    - name: JAEGER_AGENT_PORT
      value: "5755"
    image: centos
    name: promdebug
    resources: {}
  restartPolicy: Never
  serviceAccount: po-kube-prometheus-stack-prometheus
EOF
```
### build from source
```bash
kubectl exec -ti promdebug bash
yum install -y golang git python3-pip vim make
pip3 install yamllint
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bash_profile
nvm install v16.13.0

git clone -b v2.31.1 --depth 1 https://github.com/prometheus/prometheus
cd prometheus/
make build
# build only
GO111MODULE=on /root/go/bin/promu build --prefix /prometheus
```
### run prometheus
```bash
./prometheus --config.file=/tmp/prometheus.yaml
```
### port forward to local
```bash
kubectl port-forward pod/promdebug 9090
```
