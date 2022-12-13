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
```
