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

### Alicloud secrer engine
VPATH=$(vault secrets list | grep alicloud | awk {'print $1'})
vault read ${VPATH}/config
VROLE=$(vault list ${VPATH}/role | tail -1)
LEASEID=$(vault read ${VPATH}/creds/${VROLE} |grep lease_id | awk {'print $2'})
vault lease revoke ${LEASEID}

### Issue
vault secret engine for alicloud won't be worked for 1.11.5-1.12
* [vault secret engine for alicloud issue](https://github.com/hashicorp/vault/issues/6226)
* [vault secret engine for alicloud issue](https://github.com/hashicorp/vault-plugin-auth-alicloud/pull/43)
* [vault secret engine for alicloud issue](https://github.com/hashicorp/vault/pull/18021)

### Reference
* [vault-helm](https://github.com/hashicorp/vault-helm)
* [process memory](https://github.com/hashicorp/vault/issues/1446)
* [secret is missing inline_policies internal data](https://github.com/hashicorp/vault-plugin-secrets-alicloud/issues/49)
* [Vault Authenticate and authorize AzureAD](https://www.itinsights.org/HashiCorp-Vault-Authenticate-and-authorize-AzureAD-Users/#Enable-Auth-Method)
* [Azure Active Directory with OIDC Auth Method](https://learn.hashicorp.com/tutorials/vault/oidc-auth-azure?in=vault/auth-methods)
* [Create an external Vault group](https://learn.hashicorp.com/tutorials/vault/oidc-auth?in=vault/auth-methods)
