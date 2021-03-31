### Installation
```bash
helm repo add external-secrets https://external-secrets.github.io/external-secrets
helm repo update

helm upgrade --install external-secrets \
  -n external-secrets \
  --create-namespace \
  -f ./values.yaml \
  external-secrets/external-secrets
```

### Reference
* [external-secrets](https://github.com/external-secrets/external-secrets)
