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

### debug
#### check pod which is not expendable
```bash
kubectl get pods -A -o=go-template='{{"namespace\tnmae\n"}}{{range .items}}{{if not .metadata.ownerReferences}}{{.metadata.namespace}}{{"\t"}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}'
kubectl describe pod <Podname> -n <namespace> | grep "Controlled By"
```

#### check non-running pod request resource
```bash
kubectl get pods -A -o=go-template='{{"namespace\tnmae\trequest\n"}}{{range .items}}{{if ne .status.phase "Running"}}{{.metadata.namespace}}{{"\t"}}{{.metadata.name}}{{"\t"}}{{range .spec.containers}}{{if .resources.requests.cpu}}{{"cpu:"}}{{.resources.requests.cpu}}{{"\t"}}{{end}}{{if .resources.requests.memory}}{{"memory:"}}{{.resources.requests.memory}}{{"\t"}}{{end}}{{end}}{{"\n"}}{{end}}{{end}}'
```

### Patch virtual-kubelet for cluster-autoscaler
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

### Alicloud image
```bash
  registry-vpc.us-east-1.aliyuncs.com/acs/autoscaler:v1.3.1-1655566
```

### Reference
* [cluster-autoscaler-chart](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler-chart)
* [patch for virtual-kubelet](https://github.com/kubernetes/autoscaler/pull/3152)
