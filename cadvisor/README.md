# get admin token
```
export TOKEN=$(kubectl get secret -n kube-system $(kubectl get sa admin -o json -n kube-system | jq -r '.secrets[].name') -o json | jq -r '.data.token' | base64 --decode)
echo ${TOKEN} > /tmp/admin.token
```
# query cadvisor metrics from node:10250
```
kubectl cp /tmp/admin.token test-pod:/tmp/admin.token
kubectl exec -ti test-pod bash
export TOKEN=$(cat /tmp/admin.token)
curl -k -H "Authorization: Bearer ${TOKEN}" https://<node_ip>:10250/metrics/cadvisor
curl -k -s -H 'Authorization: Bearer ${TOKEN}' https://<apiserver_ip>:6443/api/v1/nodes/<node-name>/proxy/stats/summary | jq '.pods[0].containers[0].rootfs.usedBytes'
kubectl get --raw "/api/v1/nodes/<node-name>/proxy/stats/summary" | jq -r '.pods[] | select(.podRef.name == "<pod_name>") | .volume[] | select (.name == "<volume_name>") | .usedBytes'
kubectl get --raw "/api/v1/nodes/us-east-1.10.21.34.3/proxy/stats/summary" | jq -r '.pods[] | select(.podRef.name == "frontend-ci-high-memory-runner-xbgxc-9nrxq") | .containers[] | select (.name == "docker") | .rootfs.usedBytes'
kubectl get --raw "/api/v1/nodes/<node-name>/proxy/stats/summary" | jq -r '.pods[] | select(.podRef.name == "<pod_name>") | ."ephemeral-storage".usedBytes
```
