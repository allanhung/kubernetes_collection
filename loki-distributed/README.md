#### Prerequisites
* add grafana helm repo
```bash
  $ helm repo add grafana https://grafana.github.io/helm-charts
  $ helm repo update
```
* setup etcd for loki ring
```bash
helm upgrade --install loki-etcd \
  -n loki \
  --create-namespace \
  -f values.yaml \
  bitnami/etcd
```

#### Upgrade / Install
```bash
helm upgrade --install loki-distributed \
  -n loki \
  --create-namespace \
  -f values.yaml \
  grafana/loki-distributed
```

### Dashboard
* [10880](https://grafana.com/grafana/dashboards/10880)

### Reference
* [loki distributed](https://github.com/grafana/helm-charts/tree/main/charts/loki-distributed)
* [loki installation](https://www.jianshu.com/p/36db91668add)
