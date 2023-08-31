### Loki Distributed with alicloud OSS

#### Prerequisites
* create oss bucket through terraform

#### Upgrade / Install
```bash
helm dependency update
helm upgrade --install loki \
  -n logging \
  --create-namespace \
  -f values.yaml \
  -f values.example.yaml \
  --set loki-distributed.AccessKey=my-access-key \
  --set loki-distributed.SecretKey=my-secret-key \
  ./
```

#### Upgrade From 0.30.x
```bash
# Delete the Ingesters StatefulSets
kubectl delete statefulset loki-loki-distributed-ingester --cascade=orphan -n logging
# Delete the Queriers StatefulSets
kubectl delete statefulset loki-loki-distributed-querier --cascade=orphan -n logging
```

### Troubleshooting
* msg="error removing stale clients" err="empty ring"
* msg="found an existing instance(s) with a problem in the ring, this instance cannot become ready until this problem is resolved. The /ring http endpoint on the distributor (or single binary) provides visibility into the ring." ring=ingester err="instance loki-loki-distributed-ingester-2 past heartbeat timeout"
```bash
kubectl scale deploy loki-loki-distributed-distributor --replicas=0
etcdctl get loki --prefix --keys-only
etcdctl del loki/distributor
etcdctl del loki --prefix  --from-key=true
```
* prober detected unhealthy status
```bash
etcdctl member remove <member_id>
```

### Reset etcd cluster
```bash
kubectl edit statefulset/loki-etcd
set ETCD_INITIAL_CLUSTER_STATE=new
```

### Replace stdout F
* using cri parser

### Reference
* [loki distributed](https://github.com/grafana/helm-charts/tree/main/charts/loki-distributed)
* [loki debug](https://www.jianshu.com/p/6b24340c2cf1)
* [Loki Community Meeting 2021-07-01](https://www.youtube.com/watch?v=ppUrF7OMyks)
* [Loki ruler not evaluting rules (err wrong chunk metadata)](https://github.com/grafana/loki/issues/3609#issuecomment-822168648)
* [Loki as Prometheus data source is no longer supported](https://github.com/grafana/grafana/pull/34650)
* [promtail configuration for cri](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#cri)
