#### Prerequisites
```bash
helm repo add spark-operator https://googlecloudplatform.github.io/spark-on-k8s-operator
helm repo update

kubectl create ns spark
``` 

#### Upgrade / Install
```bash 
helm upgrade --install spark-operator \
  -n spark-operator \
  --create-namespace \
  -f ${DIR}/values.yaml \
  --set ingressUrlFormat="{{$appName}}.mydomain.com" \
  spark-operator/spark-operator
```

### Build custom spark image
After build the image, you have to specify image in sparkapplication
#### With monitoring
```bash
from gcr.io/spark-operator/spark:v3.1.1-gcs-prometheus
```
```bash
from gcr.io/spark-operator/spark:v3.1.1

# Setup for the Prometheus JMX exporter.
# Add the Prometheus JMX exporter Java agent jar for exposing metrics sent to the JmxSink to Prometheus.
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.11.0/jmx_prometheus_javaagent-0.11.0.jar /prometheus/
RUN chmod 644 /prometheus/jmx_prometheus_javaagent-0.11.0.jar
RUN mkdir -p /etc/metrics/conf
COPY metrics.properties /etc/metrics/conf
COPY prometheus.yaml /etc/metrics/conf
```
#### Without monitoring
```bash
from gcr.io/spark-operator/spark:v3.1.1
```

### Run sparkapplication with alicloud eci
* annotations: Add the k8s.aliyun.com/eci-use-specs annotation to specify the specifications of the ECI to be created for running a pod. You can specify the specifications in a list and separate them with commas (,). Each element in the list represents a set of specifications. When instances of the specifications specified by an element are out of stock, the specifications specified by the next element are used.
```yaml
  annotations:
    k8s.aliyun.com/eci-use-specs: '4-8Gi'
    k8s.aliyun.com/eci-spot-strategy: "SpotAsPriceGo"
    k8s.aliyun.com/eci-image-cache: "true"
```
* tolerations
```yaml
  tolerations:
  - key: "virtual-kubelet.io/provider"
    operator: "Exists"
```
#### example
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

### Example prometheus metrics with SparkApplication
```yaml
  monitoring:
    exposeDriverMetrics: true
    exposeExecutorMetrics: true
    prometheus:
      jmxExporterJar: "/prometheus/jmx_prometheus_javaagent-0.11.0.jar"
      portName: metrics
      port: 8090
```

### Spark memory
* `memory size` =  `memory`  + `memoryOverhead`
* memoryOverhead could be specified in config or calculate with memoryOverheadFactor
```bash
memoryOverhead = memory * memoryOverheadFactor
```

Reference:
* [Pod annotations supported by ECI](https://www.alibabacloud.com/help/doc-detail/144561.htm)
* [Initial job has not accepted any resources](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/issues/895)
* [Dockerfile for spark image](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/Dockerfile)
* [custom spark image](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/tree/master/spark-docker)
* [using-secrets-as-environment-variables](https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/docs/user-guide.md#using-secrets-as-environment-variables)
