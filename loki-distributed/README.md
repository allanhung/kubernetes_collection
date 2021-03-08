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

### Reference
* [loki distributed](https://github.com/grafana/helm-charts/tree/main/charts/loki-distributed)
