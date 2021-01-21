## Installation
```bash
helm repo add kiali https://kiali.org/helm-charts
helm repo update
helm upgrade --install kiali-operator \
    --namespace kiali-operator \
    --create-namespace \
    --set cr.create=true \
    --set cr.namespace=istio-system
    kiali/kiali-operator
```

## Uninstall
```bash
kubectl delete kiali kiali -n istio-system
helm uninstall kiali-operator -n kiali-operator
kubectl delete crd monitoringdashboards.monitoring.kiali.io
kubectl delete crd kialis.kiali.io
kubectl patch kiali kiali -n istio-system -p '{"metadata":{"finalizers": []}}' --type=merge
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
openssl s_client -showcerts -connect oidc-proxy.my-domian:443 < /dev/null
```

## Build
```bash
docker build -t /kiali:v1.28.1 .
```

# reference
* [kiali_cr.yaml](https://github.com/kiali/kiali-operator/blob/master/deploy/kiali/kiali_cr.yaml)
* [kiali hel charts](https://github.com/kiali/helm-charts)
* [log_level](https://github.com/kiali/kiali/pull/3382/files#diff-894630a7ed925c7768a861c4465bc9ad393f7937df7cac5c77ab123c03921aeeR123)
* [log_level setting](https://github.com/kiali/kiali/issues/2893#issuecomment-711290479)
* [openid client](https://github.com/kiali/kiali/blob/master/kubernetes/client_factory.go#L101)
