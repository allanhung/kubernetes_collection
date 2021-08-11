# External DNS
    
### Installation    

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami

helm upgrade --install exdns \
  --namespace infra \
  --create-namespace \
  -f values.yaml \
  -f values.alicloud.yaml \
  bitnami/external-dns
```

### Disable external-dns for specific resources
set blacklist by annotation
```yaml
annotations:
  external-dns.alpha.kubernetes.io/exclude: 'true'
```

### Troubleshooting
failed to sync cache: timed out waiting for the condition
* check the source from args to see if custom resources are installed
```yaml
      - args:
        - --source=service
        - --source=ingress
```
* check clusterrole to see if the permission is correct

## Reference
* [external-dns](https://github.com/kubernetes-sigs/external-dns)
* [external-dns alibabacloud tutorial](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/alibabacloud.md)
* [bitnami external-dns helm chart](https://github.com/bitnami/charts/tree/master/bitnami/external-dns)
* [Disable external-dns for specific ingresses](https://github.com/kubernetes-sigs/external-dns/issues/1910)
