### Prerequisites
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### Generate default values
```bash
helm search repo etcd
helm pull bitnami/etcd --version 5.5.0
helm show values etcd-5.5.0.tgz > values.yaml
```

### Create extra env for etcd
```bash
kubectl -n etcd create configmap etcd-env-vars \
  --from-literal=ETCD_HEARTBEAT_INTERVAL=150 \
  --from-literal=ETCD_MAX_REQUEST_BYTES=10485760 \
  --from-literal=ETCD_QUOTA_BACKEND_BYTES=8589934592 \
  --from-literal=ETCD_SNAPSHOT_COUNT=10000 \
  --from-literal=ETCD_AUTO_COMPACTION_RETENTION=1 \
  --from-literal=ETCD_ELECTION_TIMEOUT=1500
```

### Upgrade / Install
```bash
helm upgrade --install etcd \
  -n etcd \
  --create-namespace \
  -f values.yaml \
  bitnami/etcd
```

### Trouble Shooting
* member not found
```bash
etcdctl member list
etcdctl member remove <member_id>
# remove member_id file
rm -f /bitnami/etcd/data/member_id
```

### Reference
* [etcd](https://github.com/bitnami/charts/tree/master/bitnami/etcd)
* [loki-etcd](https://www.jianshu.com/p/f9ab6296ff29)
