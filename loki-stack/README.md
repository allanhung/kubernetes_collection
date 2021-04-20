## Vault Helm Chart
### Installation
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade loki grafana/loki-stack --install --create-namespace \
    --namespace logging \
    -f values.yaml \
    -f values.example.yaml
```

### Dashboard
* [12019](https://grafana.com/grafana/dashboards/12019)
* [10880](https://grafana.com/grafana/dashboards/10880)

### Patch storage size
kubectl -n logging patch pvc storage-loki-0 -p '{"spec":{"resources":{"requests":{"storage":"20Gi"}}}}'

### syslog testing
logger --rfc5424 --tcp --server loki-promtail-syslog --port 1514 test message

### Retention check
```bash
kubectl exec -ti loki-0 sh
stat /data/loki/index/index_xxxx
stat /data/loki/chunks/index/index_xxxx
stat /data/loki/boltdb-shipper-compactor/index_xxxx
stat /data/loki/boltdb-shipper-active/index_xxxx
stat /data/loki/boltdb-shipper-cache/index_xxxx
```

### chunk format
```
ls -ltr /data/loki/chunks/ | tail -1 | awk {'print $NF'} | base64 -d
fake/25a424e83214ff4b:17649e94cca:17649e9616b:e31c0f99
fake/170388d32de312:17649e95830:17649e95832:c5f425d4
```

### Timeout when attaching volumes in Kubernetes
* Workaround: Removing fsGroup from the Pod template.
* [issue](https://github.com/kubernetes/kubernetes/issues/67014)

###
* level=error ts=2020-12-31T14:50:28.748371754Z caller=flush.go:199 org_id=fake msg="failed to flush user" err="open /data/loki/chunks/ZmFrZS9iOWI4ZWM0MTIyYzI3ZmM5OjE3NmI5MmQ2OGUxOjE3NmI5MmQ2OGUyOjQ1OWIxNjVh: no space left on device"
* grep 'Directory index full' /var/log/messages
* Disabled dir_index on the ext4 volume
```bash
tune2fs -O "^dir_index" /dev/vdb
```
* check
```bash
tune2fs -l /dev/vdb
```

### Reference
* [loki](https://github.com/grafana/loki/tree/master/production/helm)
* [loki configuration](https://grafana.com/docs/loki/latest/configuration/#configuring-loki)
* [promtail configuration](https://grafana.com/docs/loki/latest/clients/promtail/configuration)
* [Loki and alerts](https://github.com/grafana/loki/issues/340)
* [Alert on your Loki logs with Grafana](https://www.youtube.com/watch?v=GdgX46KwKqo)
* [Loki future](https://www.youtube.com/watch?v=TcmvmqbrDKU)
* [Retention/Deleting old data doesn't work](https://github.com/grafana/loki/issues/881)
* [boltdb](https://github.com/boltdb/bolt)
* [bolter](https://github.com/hasit/bolter)
* [storage](https://grafana.com/docs/loki/latest/operations/storage)
* [Grafana loki source code](https://aleiwu.com/post/grafana-loki)
* [Loki reports "no space left on device" but there's plenty of space/inodes](https://github.com/grafana/loki/issues/1502)
* [Timeout when attaching volumes in Kubernetes](https://support.cloudbees.com/hc/en-us/articles/360035837431-Timeout-when-attaching-volumes-in-Kubernetes)
* [fsGroupChangePolicy](https://kubernetes.io/blog/2020/12/14/kubernetes-release-1.20-fsgroupchangepolicy-fsgrouppolicy/)
* [fsgroup recursive chown pr](https://github.com/kubernetes/kubernetes/pull/88488)
* [fsgroup source code](https://github.com/kubernetes/kubernetes/blob/master/pkg/volume/volume_linux.go)
