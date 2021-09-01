## Jaeger Operator Helm Chart
### Installation
```bash
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

helm upgrade --install jaeger-operator \
    --namespace tracing \
    --create-namespace \
    -f values.yaml \
    jaegertracing/jaeger-operator
```
