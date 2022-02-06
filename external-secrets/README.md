### Installation
```bash
helm repo add external-secrets https://charts.external-secrets.io
helm repo update

helm upgrade --install external-secrets \
  -n external-secrets \
  --create-namespace \
  -f ./values.yaml \
  external-secrets/external-secrets
```

### Reference
* [external-secrets](https://github.com/external-secrets/external-secrets)
