### Create test resource
```bash
kubectl apply -f deploy.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
```

### Inject sidecar
```bash
./inject.sh
```

### Setup nginx
```bash
./setup.sh
```

### enable envoy access log
```bash
kubectl apply -f enable_access_log_json.yaml
```

### View log
```bash
./log.sh
```

### rollback
```bash
./rollback.sh
```
