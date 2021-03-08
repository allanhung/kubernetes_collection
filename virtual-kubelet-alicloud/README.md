#### Upgrade / Install
```bash
helm repo add ali-incubator https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts-incubator/
helm repo update

helm upgrade --install vk \
    --namespace infra \
    -f ${DIR}/values.yaml \
    -f ${DIR}/values.example.yaml \
    ali-incubator/ack-virtual-node

test -d ${DIR}/vk-affinity-admission-controller || git clone --depth 1 https://github.com/lachie83/vk-affinity-admission-controller
patch -p1 < ali-vk-webhook.patch
helm upgrade --install vk-webhook \
    --namespace infra \
    --create-namespace \
    -f ${DIR}/values.yaml \
    -f ${DIR}/values.example.yaml \
    ${DIR}/vk-affinity-admission-controller/charts/vk-affinity-admission-controller
rm -rf ${DIR}/vk-affinity-admission-controller
```

### Test
```bash
kubectl run nginx --image nginx -l eci=true
```

### Prevent daemonset schedule to Virtual Kubelet
```yaml
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: type
            operator: NotIn
            values:
            - virtual-kubelet
```

### Patch for cluster-autoscaler
#### providerid
```bash
kubectl patch node virtual-node-eci-0 -p '{"spec":{"providerID":"us-east-1.virtual-node-eci-0"}}'
```

#### max cpu cores and memory
```bash
# default in virtual-kubelet
  allocatable:
    cpu: 1M
    ephemeral-storage: 60000Gi
# default in cluster-autoscaler
  // DefaultMaxClusterCores is the default maximum number of cores in the cluster.
  DefaultMaxClusterCores = 5000 * 64
  // DefaultMaxClusterMemory is the default maximum number of gigabytes of memory in cluster.
  DefaultMaxClusterMemory = 5000 * 64 * 20
```

### support tail -f
* [806](https://github.com/virtual-kubelet/virtual-kubelet/pull/806)

### remove lable
```bash
kubectl label node virtual-node-eci-0 failure-domain.beta.kubernetes.io/zone-
```
some metrics might need to ignore virtual-kubelet
node!~"virtual-node.*"

https://github.com/kubernetes/autoscaler/pull/3152
