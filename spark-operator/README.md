#### Upgrade / Install
```bash 
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm repo update
kubectl create ns spark-operator
kubectl create ns spark

helm upgrade --install sparkoperator \
  -n spark-operator \
  -f ${DIR}/values.yaml \
  -f ${DIR}/values.${ENV}.yaml \
  incubator/sparkoperator

kubectl apply -f servicemonitor.yaml
```

### To build Spark image for K8 
```bash
docker build -t allanhung/spark:v3.0.0-gcs-prometheus
docker push allanhung/spark:v3.0.0-gcs-prometheus
``` 

### Run sparkapplication with eci
- Add annotations
- Add tolerations

Add the k8s.aliyun.com/eci-use-specs annotation to specify the specifications of the ECI to be created for running a pod. You can specify the specifications in a list and separate them with commas (,). Each element in the list represents a set of specifications. When instances of the specifications specified by an element are out of stock, the specifications specified by the next element are used.

```yaml
executor:
  cores: 4
  instances: 3
  memory: "4G"
  annotations:      
    k8s.aliyun.com/eci-use-specs: '4-8Gi'
    k8s.aliyun.com/eci-spot-strategy: "SpotAsPriceGo"
    k8s.aliyun.com/eci-image-cache: "true"
  tolerations:
  - key: "virtual-kubelet.io/provider"
    operator: "Exists"
```

### Add metrics with SparkApplication
```yaml
  monitoring:
    exposeDriverMetrics: true
    exposeExecutorMetrics: true
    prometheus:
      jmxExporterJar: "/prometheus/jmx_prometheus_javaagent-0.11.0.jar"
      port: 8090
```

### Test monitor
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/spark-on-k8s-operator/master/examples/spark-pi-prometheus.yaml -n spark

Reference:
* [Pod annotations supported by ECI](https://www.alibabacloud.com/help/doc-detail/144561.htm)
