### Installation
```bash
helm upgrade --install jmx-exporter \
    --namespace monitoring \
    -f values.yaml \
    -f values.example.yaml \
    ./charts
```

### Dashboard
* [7589](https://grafana.com/grafana/dashboards/7589)
* [12766](https://grafana.com/grafana/dashboards/12766)
* [12483](https://grafana.com/grafana/dashboards/12483)
* [11963](https://grafana.com/grafana/dashboards/11963)
* [11172](https://grafana.com/grafana/dashboards/11172)
* [8582](https://grafana.com/grafana/dashboards/8582)
* [5468](https://grafana.com/grafana/dashboards/5468)
* [721](https://grafana.com/grafana/dashboards/721)

### Reference
* [kafka exporter](https://github.com/danielqsj/kafka_exporter)
* [bitnami helm chart](https://github.com/bitnami/charts/tree/master/bitnami/kafka)
* [helm chart](https://github.com/gkarthiks/helm-charts/tree/master/charts/prometheus-kafka-exporter)
* [Monitoring Kafka with Prometheus](https://www.robustperception.io/monitoring-kafka-with-prometheus)
* [Monitoring Kafka with Burrow and Prometheus Operator](https://github.com/ignatev/burrow-kafka-dashboard)
* [alert rule](https://awesome-prometheus-alerts.grep.to/rules#kafak)
