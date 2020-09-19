### Installation
```bash
helm upgrade --install po \
    --namespace monitoring  \
    -f values.yaml \
    -f values.example.yaml \
    stable/prometheus-operator
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

### Reference
* [alertmanager api](https://raw.githubusercontent.com/prometheus/alertmanager/master/api/v2/openapi.yaml)
