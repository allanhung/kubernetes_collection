# patch pv reclaim policy to Retain
```
kubectl patch pv -p "{\"spec\":{\"persistentVolumeReclaimPolicy\":\"Retain\"}}" pvname
```
# export pv
```
kubectl get pv pvname -o yaml > pv.yaml
```
# edit pv to delete the spec.claimRef part
# edit pv.yaml and delete the metadata.deletionTimestamp part
# create pv
```
kubectl create -f pv.yaml
```
