## Echo Server Helm Chart
### Installation
```bash
helm repo add ealenn https://ealenn.github.io/charts
helm repo update
helm upgrade echo-server ealenn/echo-server --install \
  --namespace debug \
  --create-namespace \
  -f values.yaml
```

### Reference

* [helm hub](https://hub.helm.sh/charts/ealenn/echo-server)
* [echo-server](https://github.com/Ealenn/echo-server)
* [echo-server-helm](https://github.com/Ealenn/charts)
* [httpreqinfo](https://github.com/koron/httpreqinfo)
