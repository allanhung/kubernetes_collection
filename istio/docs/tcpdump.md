### Install Krew
```
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
```
### Add the custom index to krew
```bash
kubectl krew index add awesome-kubectl-plugins https://github.com/ishantanu/awesome-kubectl-plugins.git
```
### Install a plugin from the custom index
```bash
kubectl krew install awesome-kubectl-plugins/ksniff
```
### tcpdump

```bash
kubectl sniff -p -n ${NS} ${POD} -o /tmp/packet
kubectl sniff -p -n ${NS} ${POD} -c istio-proxy -f 'tcp[tcpflags] & (tcp-syn|tcp-fin|tcp-rst) != 0' -i lo
```

### Reference
* [Krew](https://krew.sigs.k8s.io/docs/user-guide/setup/install/)
* [awesome-kubectl-plugins](https://github.com/ishantanu/awesome-kubectl-plugins)
