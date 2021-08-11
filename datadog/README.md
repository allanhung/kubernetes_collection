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

# References
* [helm charts](https://github.com/DataDog/helm-charts)
* [configuration](https://github.com/DataDog/datadog-agent/blob/main/pkg/config/config.go)
* [Datadog-agent does not forward metrics to own statsd server](https://github.com/DataDog/datadog-agent/issues/2358)
