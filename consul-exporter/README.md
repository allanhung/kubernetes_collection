### Installation
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install consul-exporter \
    --namespace monitoring  \
    -f values.yaml \
    -f values.example.yaml \
    prometheus-community/prometheus-consul-exporter
```        

### Dashboard
* [12049](https://grafana.com/grafana/dashboards/12049)

### Reference
* [consul-exporter](https://github.com/prometheus/consul_exporter)
* [alertrule](https://awesome-prometheus-alerts.grep.to/rules#consul)
