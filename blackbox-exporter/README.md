### Installation
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade --install blackbox-exporter \
    --namespace monitoring  \
    -f values.yaml \
    -f values.example.yaml \
    prometheus-community/prometheus-blackbox-exporter
```        

### Dashboard
* [7587](https://grafana.com/grafana/dashboards/7587)

### Reference
* [blackbox-exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-blackbox-exporter)
* [alertrule](https://awesome-prometheus-alerts.grep.to/rules#blackbox)

### Debug
curl http://blackbox-exporter-prometheus-blackbox-exporter.monitoring.svc:9115/probe\?module\=http_2xx\&target\=http:%2F%2Fexample.com\&debug\=true

