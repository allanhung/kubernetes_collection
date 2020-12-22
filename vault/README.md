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

### Enable Telemetry
#### copy telemetry.tcl to pod
```bash
kubectl cp telemetry.tcl vault-0:/tmp/
```
#### login to create server config
```bash
kubectl exec -ti vault-0 -n vault sh
vault login
vault server -config /tmp/telemetry.tcl
```

### Check
```bash
kubectl exec -ti vault-0 -n vault -- vault status -tls-skip-verify
```

### Test login
```bash
vault auth list
vault read -format=json auth/my-auth/config
vault read auth/my-auth/role/my-app
curl -X POST --data '{"jwt": "'$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)'", "role": "my-app"}' http://vault:8200/v1/auth/my-auth/login
```

### Reference
* [vault-helm](https://github.com/hashicorp/vault-helm)
