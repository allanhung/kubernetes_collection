# Vault kubernetes Auth

## Create vault service account
```
helm upgrade --install vault-account ./
```

## Vault Configuration

### Enable vault kubernetes authentication 
```bash
VAULTSA=$(kubectl get secret $(kubectl get sa vault-auth -o json | jq -r '.secrets[].name') -o json | jq -r '.data.token' | base64 --decode)
vault auth enable --path=my-auth kubernetes
vault auth list
kubectl cp my-pod:/var/run/secrets/kubernetes.io/serviceaccount/..data/ca.crt ca.crt
vault write auth/my-auth/config \
  token_reviewer_jwt="${VAULTSA}" \
  kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
  kubernetes_ca_cert=@ca.crt
rm -f ca.crt
```

### Write application role
```bash
vault write auth/my-auth/role/my-role \
  bound_service_account_names=* \
  bound_service_account_namespaces=default,my-ns-1,my-ns-2 \
  policies=application \
  ttl=1h

vault read auth/my-auth/role/my-role
```

## References
* [vault-kubernetes](https://www.vaultproject.io/docs/auth/kubernetes.html)
