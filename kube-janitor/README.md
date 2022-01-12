# Kubernetes Janitor
    
### Installation    

```bash
helm upgrade --install kube-janitor \
  --namespace infra \
  --create-namespace \
  -f values.yaml \
  /.
```

## Reference
* [kube-janitor](https://codeberg.org/hjacobs/kube-janitor)
