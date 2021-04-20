## Get kubelet config
```bash
kubectl proxy --port=8001 &
export NODE_NAME="<example_node>"
curl -sSL "http://localhost:8001/api/v1/nodes/${NODE_NAME}/proxy/configz" | jq '.kubeletconfig|.kind="KubeletConfiguration"|.apiVersion="kubelet.config.k8s.io/v1beta1"' > kubelet_configz_${NODE_NAME}
```

## example setting eviction
```bash
/etc/systemd/system/kubelet.service.d/10-kubeadm.conf
--eviction-hard=imagefs.available<15%,memory.available<300Mi,nodefs.available<10%,nodefs.inodesFree<5% --cgroup-driver=systemd"
```
