### Installation
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade --install mysql-exporter \
    --namespace monitoring  \
    -f values.yaml \
    -f values.example.yaml \
    prometheus-community/prometheus-mysql-exporter

kubectl apply -f alertvalue.yaml -n monitoring
```        

### Create monitor user
* Install
```bash
CREATE USER 'exporter'@'%' IDENTIFIED BY 'password';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'192.168.1.2' WITH MAX_USER_CONNECTIONS 3;
```

### Dashboard
* [7362](https://grafana.com/grafana/dashboards/7362)

### Reference
* [mysql-exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-mysql-exporter)
* [awesome-prometheus-alerts](https://awesome-prometheus-alerts.grep.to/rules#mysql)
* [awesome-prometheus-alerts github](https://github.com/samber/awesome-prometheus-alerts/blob/master/_data/rules.yml)
* [Kubernetes+Prometheus+Operator+MySQL+Exporter](https://wiki.shileizcc.com/confluence/display/KUB/Kubernetes+Prometheus+Operator+MySQL+Exporter)
* [Relabelconfig](https://coreos.com/operators/prometheus/docs/latest/api.html#relabelconfig)
