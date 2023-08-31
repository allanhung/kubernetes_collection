### Prerequisites
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### Generate default values
```bash
helm search repo etcd
helm pull bitnami/etcd --version 5.5.0
helm show values etcd-5.5.0.tgz > values.yaml
```

### Create extra env for etcd
```bash
kubectl -n etcd create configmap etcd-env-vars \
  --from-literal=ETCD_HEARTBEAT_INTERVAL=150 \
  --from-literal=ETCD_MAX_REQUEST_BYTES=10485760 \
  --from-literal=ETCD_QUOTA_BACKEND_BYTES=8589934592 \
  --from-literal=ETCD_SNAPSHOT_COUNT=10000 \
  --from-literal=ETCD_AUTO_COMPACTION_RETENTION=1 \
  --from-literal=ETCD_ELECTION_TIMEOUT=1500
```

### Upgrade / Install
```bash
helm upgrade --install etcd \
  -n etcd \
  --create-namespace \
  -f values.yaml \
  bitnami/etcd
```

### Backup and Restore
```bash
ETCDCTL_API=3 etcdctl snapshot save snapshot.db
ETCDCTL_API=3 etcdctl snapshot status snapshot.db
ETCDCTL_API=3 etcdctl snapshot restore snapshot.db
```

### start etcd server with database file and create snapshot
```bash
# file: /var/lib/etcd/member/snap/db

# Download binary
ETCD_VER=v3.5.9
DOWNLOAD_URL=https://storage.googleapis.com/etcd

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

# start etcd server
/tmp/etcd-download-test/etcd --data-dir /var/lib/etcd

# snapshot
/tmp/etcd-download-test/etcdctl snapshot save /tmp/backup.db
```

### Trouble Shooting
* member not found
```bash
etcdctl member list
etcdctl member remove <member_id>
# remove file in data
rm -f /bitnami/etcd/data/*
```

* workaround for /opt/bitnami/scripts/libetcd.sh: line 732: ETCD_ACTIVE_ENDPOINTS: unbound variable
```bash
etcdctl member add etcd-2 --peer-urls http://etcd-2.etcd-headless.infra.svc.cluster.local:2379
echo "${MEMBER_ID}" > /var/lib/kubelet/pods/${POD_ID}/volumes/kubernetes.io~csi/${DISK_ID}/mount/data/member_id
```

### Reference
* [etcd](https://github.com/bitnami/charts/tree/master/bitnami/etcd)
* [loki-etcd](https://www.jianshu.com/p/f9ab6296ff29)
* [etcd-json-converter](https://github.com/forcemeter/etcd-json-converter)
