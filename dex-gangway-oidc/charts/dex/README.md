### Installation
```bash
helm repo add dex https://charts.dexidp.io
helm repo update

helm upgrade --install dex \
    --namespace dex \
    -f values.yaml \
    -f values.example.yaml \
    dex/dex
``` 

### Secret generate function
```bash
openssl rand -hex 16
```

### Reference
* [dex helm charts](https://github.com/dexidp/helm-charts)
