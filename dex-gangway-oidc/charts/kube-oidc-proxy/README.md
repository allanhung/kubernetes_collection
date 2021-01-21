### Installation

* clone chart from github
```
git clone --depth 1 https://github.com/jetstack/kube-oidc-proxy kube-oidc-proxy
patch -p1 < ingress.patch
```
* Get gangway.clientID from dex, set in values.example.yaml
```
helm upgrade --install gangway-proxy \
    --namespace dex \
    --create-namespace \
    -f values.yaml \
    -f values.example.yaml \
    kube-oidc-proxy/deploy/charts/kube-oidc-proxy
```
