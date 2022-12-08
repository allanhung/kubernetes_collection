### Install
```
helm repo add banzaicloud-stable http://kubernetes-charts.banzaicloud.com/branch/master
helm repo update

helm upgrade vault-secrets-webhook banzaicloud-stable/vault-secrets-webhook --install \
    --namespace vault \
    -f values.yaml \
    --wait
```

### Test
```
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  username: vault:shared/data/test#mykey
kind: ConfigMap
metadata:
  annotations:
    vault.security.banzaicloud.io/vault-addr: https://vault.mydomain.com
    vault.security.banzaicloud.io/vault-path: my-vault-path
    vault.security.banzaicloud.io/vault-role: my-application
  name: vault-test
  namespace: default
EOF
```

### Reference
* [vault-secrets-webhook](https://github.com/banzaicloud/bank-vaults/tree/master/charts/vault-secrets-webhook)
* [Error fetching image manifest](https://github.com/banzaicloud/bank-vaults/issues/1193)
