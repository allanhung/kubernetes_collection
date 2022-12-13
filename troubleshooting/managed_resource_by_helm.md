# managed resource by helm
```
export RESOURCETYPE=<resource type>
export RESOURCENAME=<resource name>
export RESOURCENAMESPACE=<resource ns>
export NAMESPACE=<helm release ns>
export RELEASENAME=<helm release name>

kubectl label --overwrite ${RESOURCETYPE} ${RESOURCENAME} app.kubernetes.io/managed-by=Helm -n ${RESOURCENAMESPACE}
kubectl annotate --overwrite ${RESOURCETYPE} ${RESOURCENAME} meta.helm.sh/release-namespace="${NAMESPACE}" -n ${RESOURCENAMESPACE}
kubectl annotate --overwrite ${RESOURCETYPE} ${RESOURCENAME} meta.helm.sh/release-name="${RELEASENAME}" -n ${RESOURCENAMESPACE}
```
