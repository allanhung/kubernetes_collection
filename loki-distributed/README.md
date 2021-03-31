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

### Troubleshooting
* msg="error removing stale clients" err="empty ring"
```bash
etcdctl get "" --prefix --keys-only
etcdctl del "" --from-key=true
```

### Reference
* [loki distributed](https://github.com/grafana/helm-charts/tree/main/charts/loki-distributed)
* [loki debug](https://www.jianshu.com/p/6b24340c2cf1)
