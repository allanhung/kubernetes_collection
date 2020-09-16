## Quid

### Installation

* clone chart from github
```
git clone --depth 1 https://github.com/jetstack/kube-oidc-proxy kube-oidc-proxy
patch -p1 < secret_config.patch
```
* Get gangway.clientID from dex, set in values.example.yaml
```
helm upgrade --install odic-proxy kube-oidc-proxy/deploy/charts/kube-oidc-proxy \
    --namespace infra \
    -f values.yaml \
    -f values.example.yaml
```
