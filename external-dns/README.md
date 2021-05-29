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

## Reference
* [external-dns](https://github.com/kubernetes-sigs/external-dns)
* [external-dns alibabacloud tutorial](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/alibabacloud.md)
* [bitnami external-dns helm chart](https://github.com/bitnami/charts/tree/master/bitnami/external-dns)
* [Disable external-dns for specific ingresses](https://github.com/kubernetes-sigs/external-dns/issues/1910)
