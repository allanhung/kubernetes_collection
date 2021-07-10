# Storage Class

A cluster administrator can address this issue by specifying the WaitForFirstConsumer mode which will delay the binding and provisioning of a PersistentVolume until a Pod using the PersistentVolumeClaim is created. PersistentVolumes will be selected or provisioned conforming to the topology that is specified by the Pod's scheduling constraints. These include, but are not limited to, resource requirements, node selectors, pod affinity and anti-affinity, and taints and tolerations.

## Local Storage Provisioner
git clone --depth=1 https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner.git
helm install -f <path-to-your-values-file> <release-name> --namespace <namespace> ./helm/provisioner

## Reference
* [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes)
* [Volume Binding Mode](https://kubernetes.io/docs/concepts/storage/storage-classes/#volume-binding-mode)
* [Topology-Aware Volume Provisioning in Kubernetes](https://kubernetes.io/blog/2018/10/11/topology-aware-volume-provisioning-in-kubernetes/)
* [Local Storage Provisioner](https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner)
