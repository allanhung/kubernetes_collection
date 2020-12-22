### Installation
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade --install adapter \
    --namespace monitoring  \
    -f values.yaml \
    prometheus-community/prometheus-adapter
```        

### Test
#### Configure
```yaml
      resources:
        overrides:
          namespace:
            resource: namespace
          service:
            resource: service
          instance:
            resource: pod
      metricsQuery: sum(<<.Series>>{<<.LabelMatchers>>}) by (<<.GroupBy>>)
```
#### request
```bash
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/my-ns/services/my-service/my-metrics"
# query: sum(my-metrics{namespace="my-ns",service="my-service"}) by (service)
kubectl get --raw '/apis/custom.metrics.k8s.io/v1beta1/namespaces/my-ns/services/*/my-metrics?labelSelector=app
# query: sum(my-metrics{namespace="my-ns",service=~"all-service"}) by (service) && filter service label which has key app
kubectl get --raw '/apis/custom.metrics.k8s.io/v1beta1/namespaces/my-ns/service/*/my-metrics?labelSelector=app%3d=foo
# query: sum(my-metrics{namespace="my-ns",service=~"all-service"}) by (service) && filter service label which has label app=foo
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/my-ns/pods/my-pod/my-metrics"
# query: sum(my-metrics{namespace="my-ns",instance="my-pod"}) by (instance)
kubectl get --raw '/apis/custom.metrics.k8s.io/v1beta1/namespaces/my-ns/pods/my-pod/my-metrics?labelSelector=app%3d=foo
# query: sum(my-metrics{namespace="my-ns",instance="my-pod"}) by (instance) && filter service label which has label app=foo
```
#### HPA
```bash
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  labels:
    app: someApp
  name: someApp
  namespace: my-ns
spec:
  maxReplicas: 10
  minReplicas: 1
  scaleTargetRef:
    apiVersion: extensions/v1beta1
    kind: Deployment
    name: someApp
  metrics:
  - type: Object
    object:
      target:
        apiVersion: v1
        kind: Service
        name: my-service
      metricName: my-metrics
      targetValue: 100
```

### Check
```bash
kubectl get apiservices | grep prometheus-adapter
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1"
```

### Reference
* [prometheus-adapter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-adapter)
* [walkthrough](https://github.com/DirectXMan12/k8s-prometheus-adapter/blob/master/docs/walkthrough.md)
* [config](https://github.com/DirectXMan12/k8s-prometheus-adapter/blob/master/docs/config.md)
* [issue 292](https://github.com/DirectXMan12/k8s-prometheus-adapter/issues/292)
* [Custom Metrics API](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/instrumentation/custom-metrics-api.md)
* [External Metrics API](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/instrumentation/external-metrics-api.md)
