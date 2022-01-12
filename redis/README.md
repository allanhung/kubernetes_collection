### Installation
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install redis \
    --namespace redis  \
    -f values.yaml \
    bitnami/redis
```

### Reference
* [redis](https://github.com/bitnami/charts/tree/master/bitnami/redis)
