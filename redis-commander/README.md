### Installation
```bash
git clone --depth 1 https://github.com/joeferner/redis-commander

helm upgrade --install redis-commander \
    --namespace redis \
    --create-namespace \
    -f ./values.yaml \
    -f ./values.example.yaml \
    ./redis-commander/k8s/helm-chart/redis-commander
```

### Reference
* [redis-commander](https://github.com/joeferner/redis-commander)
