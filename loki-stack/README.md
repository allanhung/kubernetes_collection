## Vault Helm Chart
### Installation
```bash
helm repo add loki https://grafana.github.io/loki/charts
helm repo update
helm upgrade loki loki/loki-stack --install --create-namespace \
    --namespace logging \
    -f values.yaml \
    -f values.example.yaml
```

### Dashboard
* [12019](https://grafana.com/grafana/dashboards/12019)
* [10880](https://grafana.com/grafana/dashboards/10880)

### Alerts

### syslog testing
logger --rfc5424 --tcp --server loki-promtail-syslog --port 1514 test message

### Reference
* [loki](https://github.com/grafana/loki/tree/master/production/helm)
* [loki configuration](https://grafana.com/docs/loki/latest/configuration/#configuring-loki)
* [promtail configuration](https://grafana.com/docs/loki/latest/clients/promtail/configuration)
* [Loki and alerts](https://github.com/grafana/loki/issues/340)
* [Alert on your Loki logs with Grafana](https://www.youtube.com/watch?v=GdgX46KwKqo)
* [Loki future](https://www.youtube.com/watch?v=TcmvmqbrDKU)
