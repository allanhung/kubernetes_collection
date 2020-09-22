## Cluster-Autoscaler Helm Chart
### Installation
```bash
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm upgrade cas autoscaler/cluster-autoscaler-chart --install \
    --namespace kube-system \
    -f values.yaml
```

### Dashboard
* [10692](https://grafana.com/grafana/dashboards/10692)

### Reference
* [cluster-autoscaler-chart](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler-chart)
