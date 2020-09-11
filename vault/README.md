## Vault Helm Chart
### Installation
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
kubectl create ns vault
kubectl config set-context --current --namespace=vault
helm upgrade vault hashicorp/vault --install \
    --namespace vault \
    -f values.yaml
```

### Initialized and Unsealed
```bash
kubectl exec -ti vault-0 -n vault -- vault operator init
kubectl exec -ti vault-0 -n vault -- vault operator unseal
kubectl exec -ti vault-0 -n vault -- vault operator unseal
kubectl exec -ti vault-0 -n vault -- vault operator unseal
```

### Check
```bash
kubectl exec -ti vault-0 -n vault -- vault status -tls-skip-verify
```

### Reference
* [vault-helm](https://github.com/hashicorp/vault-helm)
