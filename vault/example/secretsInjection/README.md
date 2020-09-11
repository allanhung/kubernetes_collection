kubectl cp app-policy.hcl vault-0:/tmp/
kubectl exec -ti vault-0 -n vault sh
```bash
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
kubectl create sa app -n demo
kubectl apply -f demo_app.yaml -n demo
```

### check
```bash
export POD_POSTFIX=6b86866f5-j2mkg
kubectl exec -ti centos-debug-${POD_POSTFIX} -n demo -- ls -l /vault/secrets
```

### patch and check again
```bash
kubectl patch deployment centos-debug --patch "$(cat annotations_patch.yaml)" -n demo
export POD_POSTFIX=587c766785-99mv5
kubectl exec -ti centos-debug-${POD_POSTFIX} -n demo -- ls -l /vault/secrets
kubectl exec -ti centos-debug-${POD_POSTFIX} -n demo -- cat /vault/secrets/foo
```

## Reference
* [injecting-vault-secrets-into-kubernetes-pods](https://www.hashicorp.com/blog/injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar)
* [secrets-engines](https://www.vaultproject.io/intro/getting-started/secrets-engines)
* [injector](https://www.vaultproject.io/docs/platform/k8s/injector)
