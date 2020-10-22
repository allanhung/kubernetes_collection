## Vault Helm Chart
### Installation
```bash
helm repo add allanhung https://allanhung.github.io/vault-exporter
helm repo update
helm upgrade vault-exporter allanhung/vault-exporter --install --create-namespace \
    --namespace vault \
    -f values.yaml \
    -f values.example.yaml
```

### Reference
* [vault-exporte](https://github.com/allanhung/vault-exporter)
* [vault-monitoring](https://coreos.com/tectonic/docs/latest/vault-operator/user/monitoring.html)
