# Datadog Agent on Kubernetes

# Installation 

```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update
helm upgrade --install datadog \
    --namespace monitoring \
    --create-namespace \
    -f datadog/values.yaml \
    datadog/datadog
```

# Test
```
echo -n "test_metrics:60|g|#shell" | nc -4u -w0 127.0.0.1 8125
```
The metrics should be found in metrics --> explorer in datadog web.

# Patch datadog to run deployment in kubernetes
```
helm repo add datadog https://helm.datadoghq.com
helm repo update
helm pull datadog/datadog --untar
patch -p1 < datadog.patch
```

# References
* [helm charts](https://github.com/DataDog/helm-charts)
* [configuration](https://github.com/DataDog/datadog-agent/blob/main/pkg/config/config.go)
* [Datadog-agent does not forward metrics to own statsd server](https://github.com/DataDog/datadog-agent/issues/2358)
