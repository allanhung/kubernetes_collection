### Installation
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade --install adapter \
    --namespace monitoring  \
    -f values.yaml \
    prometheus-community/prometheus-adapter
```        

### Check
```bash
kubectl get apiservices | grep prometheus-adapter
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1"
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/infra/services/my-service/my-metrics"
```

### Reference
* [prometheus-adapter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-adapter)
* [walkthrough](https://github.com/DirectXMan12/k8s-prometheus-adapter/blob/master/docs/walkthrough.md)
* [config](https://github.com/DirectXMan12/k8s-prometheus-adapter/blob/master/docs/config.md)
* [issue 292](https://github.com/DirectXMan12/k8s-prometheus-adapter/issues/292)
