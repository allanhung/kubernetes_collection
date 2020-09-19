## Cluster-Autoscaler Helm Chart
### Installation
```bash
helm repo add autoscaler https://kubernetes.github.io/autoscaler
helm upgrade cas autoscaler/cluster-autoscaler-chart --install \
    --namespace kube-system \
    -f values.yaml
```

### Create dashboard
```bash
bash dashboard.sh 10692 admin:admin http://grafana:3000 "Cluster AutoScaler"
```

### Reference
* [cluster-autoscaler-chart](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler-chart)
