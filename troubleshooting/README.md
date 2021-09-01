### namespace stuck in terminating
* fix any errors in api-resources
```bash
kubectl api-resources
kubectl get apiservice -n <ns>
```

* force delete namespace
```bash
export NAMESPACE=example
kubectl get namespaces ${NAMESPACE} -o json | jq '.spec.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/${NAMESPACE}/finalize" -f -
kubectl get namespaces ${NAMESPACE} -o json | jq '.metadata.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/${NAMESPACE}/finalize" -f -
```
* bash delete
```bash
kubectl get ns |grep Terminating | awk {'print $1'}|xargs  -I {} sh -c "kubectl get namespaces {} -o json | jq '.spec.finalizers = []' | kubectl replace --raw '/api/v1/namespaces/{}/finalize' -f -"
kubectl get ns |grep Terminating | awk {'print $1'}|xargs  -I {} sh -c "kubectl get namespaces {} -o json | jq '.metadata.finalizers = []' | kubectl replace --raw '/api/v1/namespaces/{}/finalize' -f -"
```

### too many pods
* terway driver use one eni instance per ip
```bash
export NODEIP=10.22.34.186
export PODKEYWORD=consul
kubectl get pods -A -o wide |grep us-east-1.${NODEIP}|awk {'print $7'} | grep -v ${NODEIP} | wc -l
kubectl get pods -A -o wide |grep ${PODKEYWORD} | awk {'print $7'} | uniq | sort
kubectl get nodes
```

### no backend server with loadbalancer
* terway not supporting string targetPort

### Clock not synchronising.
* alert criteria
```
min_over_time(node_timex_sync_status[5m]) == 0 and node_timex_maxerror_seconds >= 16
```
* checking
```
timedatectl
....
NTP synchronized: no
```
* workaround - restart ntp client
```
systemctl restart chronyd
```
* [timex](https://github.com/prometheus/node_exporter/blob/master/collector/timex.go#L167-L180)

### Reference
* [Using Finalizers to Control Deletion](https://kubernetes.io/blog/2021/05/14/using-finalizers-to-control-deletion/)
* [Instance families](https://www.alibabacloud.com/help/doc-detail/25378.htm)
* [timex collector](https://github.com/prometheus/node_exporter/blob/master/docs/TIME.md#timex-collector)
