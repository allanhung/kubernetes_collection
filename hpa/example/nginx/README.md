### Installation
#### prometheus adapter
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install adapter \
    --namespace monitoring  \
    -f values.yaml \
    prometheus-community/prometheus-adapter
```    
#### create test deployment
```bash
kubectl apply -f nginx.yaml
kubectl apply -f serivcemonitor.yaml
kubectl apply -f hpa.yaml
```

### debug
#### get metrics
```
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/nginx/services/nginx-service/nginx_server_connections"
```

### Reference
* [nginx-vts dockerfile](https://github.com/softonic/nginx-vts)
* [nginx hpa](https://www.metricfire.com/blog/prometheus-metrics-based-autoscaling-in-kubernetes/)
* [Kubernetes HPA-ExternalMetrics+Prometheus](https://blog.kloia.com/kubernetes-hpa-externalmetrics-prometheus-acb1d8a4ed50)

