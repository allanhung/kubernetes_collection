### copy app-policy.hcl to pod
```bash
kubectl cp app-policy.hcl vault-0:/tmp/
```
### login to create auth, role in vault
```bash
kubectl exec -ti vault-0 -n vault sh
vault login
vault policy write app /tmp/app-policy.hcl
vault policy list
vault policy read app
# enable kubernetes authentication
vault auth enable --path=dev kubernetes
vault auth list
vault write auth/dev/config \
   token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
   kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
   kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
# create role for kubernetes   
vault write auth/dev/role/myapp \
   bound_service_account_names=* \
   bound_service_account_namespaces=demo \
   policies=app \
   ttl=1h
vault read auth/dev/role/myapp
```
### create secret path
```bash
vault secrets list -detailed
vault secrets enable -path=secret kv
vault secrets list -detailed
```
### put secret in vault
```bash
vault kv put secret/helloworld username=foobaruser password=foobarbazpass
```

### create kubernetes app
```bash
kubectl create ns demo
kubectl apply -f demo_app.yaml -n demo
```

### check
```bash
kubectl logs -l app=debug -n demo
```

### inject vault into pod and check again
```bash
kubectl patch deployment centos-debug --patch "$(cat injection_patch_1.yaml)" -n demo
kubectl exec centos-debug-xxx -n demo -- ps aux
kubectl exec centos-debug-xxx -n demo -- env
kubectl logs -l app=debug -n demo
```

### inject vault into pod and check again
```bash
kubectl patch deployment centos-debug --patch "$(cat injection_patch_2.yaml)" -n demo
kubectl exec centos-debug-xxx -n demo -- ps aux
kubectl logs -l app=debug -n demo
```

## Reference
* [vault-secrets-webhook](https://github.com/banzaicloud/bank-vaults/tree/master/charts/vault-secrets-webhook)
* [vault-secrets-webhook docs](https://github.com/banzaicloud/bank-vaults-docs/blob/master/docs/mutating-webhook/_index.md)
