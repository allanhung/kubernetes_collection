### Installation
```bash
helm repo add niclic https://niclic.github.com/helm-charts
helm repo update

helm upgrade --install statsd-exporter \
    --namespace monitoring  \
    -f values.yaml \
    -f values.vault.yaml \
    niclic/prometheus-statsd-exporter
```        

### Reference
* [statsd-exporter](https://github.com/prometheus/statsd_exporter)
* [statsd-exporter helm chart](https://github.com/niclic/helm-charts)
* [vault-monitoring](https://coreos.com/tectonic/docs/latest/vault-operator/user/monitoring.html)
* [vault-mapping](https://gist.github.com/tam7t/64291f4ebbc1c45a1fc876b6c0613221)
* [vault-exporter](https://github.com/kubevault/vault_exporter)
* [Forward DogStatsD Metrics to Prometheus](https://marselester.com/prometheus-via-dogstatsd.html)
