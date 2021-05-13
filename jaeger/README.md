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

### debug
* Build query image
```bash
git clone https://github.com/jaegertracing/jaeger
cd jaeger && cp ../Dockerfile .
git submodule update --init --recursive
make build-ui
docker build -t allanhung/jaeger-query:1.22.0 .
```

### Reference
* [jaeger charts](https://github.com/jaegertracing/helm-charts)
* [cassandra charts](https://github.com/helm/charts/tree/master/incubator/cassandra)
* [jaeger source code analysis](https://blog.csdn.net/sniperking2008/article/details/103762543)
* [build from source](https://github.com/jaegertracing/jaeger/blob/master/CONTRIBUTING.md)
* [Error reading dependencies from storage](https://github.com/jaegertracing/jaeger/issues/1940)
* [dependency version](https://github.com/jaegertracing/jaeger/blob/master/plugin/storage/cassandra/dependencystore/bootstrap.go#L24-L28)
