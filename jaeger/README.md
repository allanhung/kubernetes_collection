## Jaeger Helm Chart
* Jaeger - All components required to run Jaeger
* Jaeger-Operator - Jaeger-Operator Deployment
* Clickhouse - Run Jaeger with clickhouse plugin

## Reference
* [jaeger charts](https://github.com/jaegertracing/helm-charts)
* [cassandra charts](https://github.com/helm/charts/tree/master/incubator/cassandra)
* [jaeger source code analysis](https://blog.csdn.net/sniperking2008/article/details/103762543)
* [build from source](https://github.com/jaegertracing/jaeger/blob/master/CONTRIBUTING.md)
* [Error reading dependencies from storage](https://github.com/jaegertracing/jaeger/issues/1940)
* [dependency version](https://github.com/jaegertracing/jaeger/blob/master/plugin/storage/cassandra/dependencystore/bootstrap.go#L24-L28)
* [Prometheus Crash Loop on Kubernetes since Jaeger added](https://github.com/prometheus/prometheus/issues/7286)
* [JAEGER_AGENT_PORT invalid syntax](https://github.com/helm/charts/issues/22769)
* [jaeger clickhouse plugin](https://github.com/bobrik/jaeger/tree/ivan/clickhouse/plugin/storage/clickhouse)
* [jaeger clickhouse](https://github.com/jaegertracing/jaeger-clickhouse)
