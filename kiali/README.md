## Installation
```bash
helm repo add kiali https://kiali.org/helm-charts
helm repo update

kubectl create secret generic kiali --from-literal="oidc-secret=$CLIENT_SECRET" -n istio-system
export KIALIVERSION=1.38.1

helm pull kiali/kiali-server --version ${KIALIVERSION} --untar 
patch -p1 < kiali.${KIALIVERSION}.patch

helm upgrade --install kiali \
    --namespace istio-system \
    --create-namespace \
    -f values.yaml \
    ./kiali-server
```

## Openid Support
* Need to set api_proxy and api_proxy_ca_data even if we use ca that has been trusted
### use system trust ca from linux ca-bundle
```bash
scp my-linux:/etc/ssl/certs/ca-bundle.trust.crt .
kubectl create secret generic ca-bundle --from-file=ca-bundle.trust.crt
```
### get server ca by openssl command
```bash
openssl s_client -showcerts -connect oidc-proxy.my-domian:443 -servername oidc-proxy.my-domian < /dev/null
openssl s_client -showcerts -connect kiali-proxy.my-domain:443 -servername kiali-proxy.my-domain < /dev/null
```

## Build for debug
```bash
docker build -t /kiali:v1.28.1 .
```

### Reference
* [kiali-helm](https://github.com/kiali/helm-charts)
* [kiali-operator generated yaml](https://repo1.dso.mil/platform-one/apps/istio/-/blob/master/generate/generated.yaml)
* [kiali_cr.yaml](https://github.com/kiali/kiali-operator/blob/master/deploy/kiali/kiali_cr.yaml)
* [kiali hel charts](https://github.com/kiali/helm-charts)
* [log_level](https://github.com/kiali/kiali/pull/3382/files#diff-894630a7ed925c7768a861c4465bc9ad393f7937df7cac5c77ab123c03921aeeR123)
* [log_level setting](https://github.com/kiali/kiali/issues/2893#issuecomment-711290479)
* [openid client](https://github.com/kiali/kiali/blob/master/kubernetes/client_factory.go#L101)
