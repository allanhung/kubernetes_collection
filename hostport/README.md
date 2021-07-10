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

## Reference
* [kube-flannel.yml](https://github.com/coreos/flannel/blob/master/Documentation/kube-flannel.yml)
* [calico install-cni-plugin](https://docs.projectcalico.org/getting-started/kubernetes/hardway/install-cni-plugin)
