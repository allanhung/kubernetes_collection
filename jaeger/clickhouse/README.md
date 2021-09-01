### Installation
```bash
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

helm pull jaegertracing/jaeger --untar
patch -p1 < clickhouse.patch
```

### Reference
[jaeger clickhouse patch](https://github.com/allanhung/helm-charts-3)
[dependency store](https://github.com/jaegertracing/jaeger-clickhouse/issues/30)
