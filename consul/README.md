## Consul Helm Chart
### Installation
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
kubectl create ns consul
kubectl config set-context --current --namespace=consul
helm upgrade consul hashicorp/consul --install \
    --namespace consul \
    -f values.yaml
kubectl apply -f ingress.yaml -n consul
```

### Reference
* [consul-helm](https://github.com/hashicorp/consul-helm)
