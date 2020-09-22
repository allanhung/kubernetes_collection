### Installation
```bash
helm upgrade --install regsecret-operator \
    --namespace infra  \
    -f my-values.yaml \
   chart/
```        

### rule patch
```
kubectl -n infra patch prometheusrules po-prometheus-operator-kubernetes-resources --record --type='json' -p '[
  {
    "op": "replace",
    "path": "/spec/groups/0/rules/5/expr",
    "value":  "sum(increase(container_cpu_cfs_throttled_periods_total{container!=\"\", }[5m])) by (container, pod, namespace)
          /
        sum(increase(container_cpu_cfs_periods_total{}[5m])) by (container, pod, namespace)
          > ( 25 / 100 )"
  }
]'
```

### amttol
* Install
```bash
go get github.com/prometheus/alertmanager/cmd/amtool
```
* example
```
export ALERTMANAGERURL=https://alertmanager
amtool --alertmanager.url ${ALERTMANAGERURL} alerts query
# add silence
amtool --alertmanager.url ${ALERTMANAGERURL} silence add alertname=AggregatedAPIDown -c 'https://github.com/helm/charts/issues/22948' -a allan -d 1y
amtool --alertmanager.url ${ALERTMANAGERURL} silence add alertname=CPUThrottlingHigh -c 'https://github.com/kubernetes-monitoring/kubernetes-mixin/issues/108' -a allan -d 1y
# update silence
amtool --alertmanager.url ${ALERTMANAGERURL} silence update -d 1y cc978047-022c-413a-b364-1bb509401f24
```

### Download dashboard from grafana
```bash
# cert-manager
bash dashboard.sh 11001 admin:admin http://grafana:3000 "Cert Manager"
# cluster autoscaler
bash dashboard.sh 10692 admin:admin http://grafana:3000 "Cluster AutoScaler"
# mysql-exporter
bash dashboard.sh 7362 admin:admin http://grafana:3000 "Database"
# redis-exporter
bash dashboard.sh 763 admin:admin http://grafana:3000 "Database" "DS_PROM"
```

### Reference
* [regsecret-operator](https://github.com/mcasimir/regsecret-operator)
