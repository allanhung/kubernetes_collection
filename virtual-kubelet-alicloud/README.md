#### Upgrade / Install
```bash
helm repo add incubator https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts-incubator/
helm repo update

helm upgrade --install vk \
    --namespace infra \
    -f ${DIR}/values.yaml \
    -f ${DIR}/values.example.yaml \
    incubator/ack-virtual-node
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
### support tail -f
* [806](https://github.com/virtual-kubelet/virtual-kubelet/pull/806)

###
```bash
kubectl label node virtual-node-eci-0 failure-domain.beta.kubernetes.io/zone-
```
some metrics might need to ignore virtual-kubelet
node!~"virtual-node.*"

https://github.com/kubernetes/autoscaler/pull/3152
