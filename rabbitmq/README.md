### Installation
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install rabbitmq \
    --namespace rabbitmq  \
    -f values.yaml \
    -f values.example.yaml \
    bitnami/rabbitmq
```

### Dashboard
* [10991](https://grafana.com/grafana/dashboards/10991)

### Reference
* [rabbitmq](https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq)
* [rabbitmq-prometheus](https://github.com/rabbitmq/rabbitmq-prometheus)
* [dashboards](https://github.com/rabbitmq/rabbitmq-prometheus/tree/master/docker/grafana/dashboards)
