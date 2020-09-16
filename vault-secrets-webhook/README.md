### Install
```
helm repo add banzaicloud-stable http://kubernetes-charts.banzaicloud.com/branch/master
helm repo update

helm upgrade vault-secrets-webhook banzaicloud-stable/vault-secrets-webhook --install \
    --namespace vault \
    -f values.yaml \
    --wait
```

### Reference
* [vault-secrets-webhook](https://github.com/banzaicloud/bank-vaults/tree/master/charts/vault-secrets-webhook)
