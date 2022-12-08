# Support hostport with alicloud managed kubernetes
## flannel driver
### configmap
```bash
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-flannel-cfg
  namespace: kube-system
  labels:
    tier: node
    app: flannel
data:
  cni-conf.json: |
    {
      "name": "cbr0",
      "cniVersion": "0.3.1",
      "plugins": [
        {
          "type": "flannel",
          "delegate": {
            "hairpinMode": true,
            "isDefaultGateway": true
          }
        },
        {
          "type": "portmap",
          "capabilities": {
            "portMappings": true
          }
        }
      ]
    }
  net-conf.json: |
    <keep origin config>
EOF
```
### patch flannel daemonset
```bash
kubectl -n kube-system patch ds kube-flannel-ds --record --type='json' -p '[
  {
    "op": "replace",
    "path": "/spec/template/spec/initContainers/0/command/2",
    "value":  "set -e -x; rm -f /etc/cni/net.d/10-flannel.conf; cp -f /etc/kube-flannel/cni-conf.json /etc/cni/net.d/10-flannel.conflist"
  }
]'
```
### restart flannel daemonset
```bash
kubectl -n kube-system delete pods -l app=flannel
```
## terway driver
### configmap
```bash
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: eni-config
  namespace: kube-system
data:
  10-terway.conf: |
    {
      "name": "terway",
      "cniVersion": "0.3.0",
      "plugins": [
        {
          "type": "terway"
        },
        {
          "type": "portmap",
          "snat": true,
          "capabilities": {"portMappings": true}
        }
      ]
    }
  <keep origin config>
EOF
```
### patch with jq
```
jq '
{
  "cniVersion": "0.3.1",
  "name": "terway-chainer",
  "plugins": [
      del(.name,.cniVersion),
      {
         "type": "cilium-cni"
      }
   ]
}' < /etc/eni/10-terway.conf > /etc/cni/net.d/10-terway.conflist
```
### patch terway daemonset
```bash
kubectl -n kube-system patch ds terway-eniip --record --type='json' -p '[
  {
    "op": "replace",
    "path": "/spec/template/spec/initContainers/0/command",
    "value":  ["sh", "-c", "/bin/init.sh && /bin/mv -f /etc/cni/net.d/10-terway.conf /etc/cni/net.d/10-terway.conflist"]
  }
]'
```
### restart terway daemonset
```bash
kubectl -n kube-system delete pods -l app=terway-eniip
```
## Test
```bash
cat << EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: hostport-test
spec:
  selector:
    matchLabels:
      app: hostport
  template:
    metadata:
      labels:
        app: hostport
    spec:
      nodeSelector:
        kubernetes.io/hostname: mynodename
      containers:
      - name: nginx
        image: nginx
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
        ports:
        - containerPort: 80
          hostPort: 10080
          name: nginx
          protocol: TCP
EOF
kubectl delete ds hostport-test
telnet <node_ip> 10080
```

### patch portmap
```
docker run -d --rm --name=go --entrypoint tail golang -f /dev/null
docker cp portmap.patch go:/tmp
docker exec -ti go bash
apt-get update && apt-get install -y patch
git clone --depth 1 https://github.com/containernetworking/plugins cni-plugins
cp cni-plugins
patch -p1 < /tmp/portmap.patch
export GOOS=linux
export GOFLAGS=" -mod=vendor"
go build -o portmap ./plugins/meta/portmap
```
### Copy binary into host
```
# Copy binary through daemonset (example: kube2ram)
patch -p1 < daemonset.initcontainer.patch
```

## Reference
* [kube-flannel.yml](https://github.com/coreos/flannel/blob/master/Documentation/kube-flannel.yml)
* [calico install-cni-plugin](https://docs.projectcalico.org/getting-started/kubernetes/hardway/install-cni-plugin)
* [Skip known non-sandbox interfaces](https://github.com/containernetworking/plugins/pull/28)
