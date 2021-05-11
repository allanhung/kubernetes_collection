## Kiali Helm Chart
### Installation
```bash
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

helm upgrade --install jaeger \
    --namespace tracing \
    --create-namespace \
    -f values.yaml \
    jaegertracing/jaeger
```

### Reference
* [jaeger helm](https://github.com/jaegertracing/helm-charts)
