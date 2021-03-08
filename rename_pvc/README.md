### PVC rename example
```bash
export STATEFULSET=my-statefulset
export ORIPVC=my-old-pvc
export NEWPVC=my-new-pvc
export ORIPV=$(kubectl get pvc ${ORIPVC} -o json | jq -r '.spec.volumeName')
export ORIPVSIZE=$(kubectl get pvc ${ORIPVC} -o json | jq -r '.spec.resources.requests.storage')

kubectl scale statefulset ${STATEFULSET} --replicas=0
kubectl delete pvc ${NEWPVC}
cat > patch.yaml << EOF
spec:
  persistentVolumeReclaimPolicy: Retain
EOF
kubectl patch pv ${ORIPV} --patch "$(cat patch.yaml)"
kubectl get pv ${ORIPV}
kubectl delete pvc ${ORIPVC}
cat > ${NEWPVC}.yaml << EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  annotations:
    pv.kubernetes.io/bind-completed: "yes"
    volume.kubernetes.io/storage-resizer: alicloud/disk
  name: ${NEWPVC}
  namespace: infra
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: ${ORIPVSIZE}
  storageClassName: topology-aware-cloud-efficiency
  volumeMode: Filesystem
  volumeName: ${ORIPV}
EOF
kubectl patch pv ${ORIPV} --type=json -p='[{"op": "remove", "path": "/spec/claimRef"}]'
kubectl apply -f ${NEWPVC}.yaml
kubectl get pvc ${NEWPVC}
cat > patch.yaml << EOF
spec:
  persistentVolumeReclaimPolicy: Delete
EOF
kubectl patch pv ${ORIPV} --patch "$(cat patch.yaml)"
kubectl get pv ${ORIPV}
kubectl scale statefulset ${STATEFULSET} --replicas=1
rm -f patch.yaml ${NEWPVC}.yaml
```
