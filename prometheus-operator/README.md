### Installation
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade --install po \
    --namespace monitoring  \
    -f values.yaml \
    -f values.example.yaml \
    prometheus-community/kube-prometheus-stack

kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/master/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
```        

### rule patch
```
kubectl -n monitoring patch prometheusrules po-kube-prometheus-stack-kubernetes-resources --record --type='json' -p '[
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

### Enable disk metrics in alicloud
```bash
kubectl set env ds/flexvolume ENABLE_METRICS_DISK=true -n kube-system
```

### Query
$ curl 'http://po-kube-prometheus-stack-prometheus:9090/api/v1/query?query=up&time=2022-05-31T02:00:00.000Z'
$ curl 'http://prometheus-server.infra.svc/api/v1/query?query=pretax_gross_amount&time=2022-08-22T16:00:00.000Z'

### Apiserver client certificate expiring
```
openssl x509 -in <cert_file> -text
tcpdump "tcp port 6443 and (tcp[((tcp[12] & 0xf0) >>2)] = 0x16) && (tcp[((tcp[12] & 0xf0) >>2)+5] = 0x01)" -w client-hello.pcap
```

### Reference
* [alertmanager api](https://raw.githubusercontent.com/prometheus/alertmanager/master/api/v2/openapi.yaml)
* [missing kubelet_volume volume metrics](https://github.com/rook/rook/issues/1659)
* [Failed to list](https://github.com/prometheus-operator/prometheus-operator/issues/3542)
* [Prometheus Operator CRD](https://github.com/prometheus-operator/prometheus-operator/blob/master/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml)
* [Prometheus operator troubleshooting](https://github.com/coreos/prometheus-operator/blob/master/Documentation/troubleshooting.md#overview-of-servicemonitor-tagging-and-related-elements)
* [Prometheus Crash Loop on Kubernetes since Jaeger added](https://github.com/prometheus/prometheus/issues/7286)
* [JAEGER_AGENT_PORT invalid syntax](https://github.com/helm/charts/issues/22769)
* [Prometheus Query](https://www.youtube.com/watch?v=09bR9kJczKM)
* [Memory usage spikes during WAL replay](https://github.com/prometheus/prometheus/issues/6934)
* [Shows apiserver client certificate expiring](https://github.com/prometheus-operator/kube-prometheus/issues/1089)
