## Jaeger Helm Chart
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

* Build query image
```bash
git clone https://github.com/jaegertracing/jaeger
cd jaeger && cp ../Dockerfile .
git submodule update --init --recursive
make build-ui
docker build -t allanhung/jaeger-query:1.22.0 .
```
