### Installation
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade --install redis-exporter \
    --namespace monitoring  \
    -f values.yaml \
    -f values.example.yaml \
    prometheus-community/prometheus-redis-exporter

kubectl apply -f alertrule.yaml -n monitoring
```        

### Dashboard
* [763](https://grafana.com/grafana/dashboards/763)

### Reference
* [redis-exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-redis-exporter)
* [awesome-prometheus-alerts](https://awesome-prometheus-alerts.grep.to/rules#redis)
* [awesome-prometheus-alerts github](https://github.com/samber/awesome-prometheus-alerts/blob/master/_data/rules.yml)
* [Relabelconfig](https://coreos.com/operators/prometheus/docs/latest/api.html#relabelconfig)
* [redis_memory_max_bytes always return 0](https://github.com/oliver006/redis_exporter/issues/300)
