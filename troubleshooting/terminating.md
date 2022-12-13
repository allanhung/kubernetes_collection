### namespace stuck in terminating
- check
```bash
export NAMESPACE=rook-ceph
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n ${NAMESPACE}
````
- should fix any errors in api-resources
```bash
kubectl api-resources
kubectl get APIService
```
- fix example:
```bash
$ kubectl api-resources
....
error: unable to retrieve the complete list of server APIs: acme.neoskop.de/v1alpha1: the server is currently unable to handle the request

$ kubectl get apiservice |grep acme
v1alpha1.acme.neoskop.de                    cert-manager/cert-manager-webhook-dnsimple                True        32m

# delete apiservice and restart pod to sync ssl certificate
$ kubectl get apiservice v1alpha1.acme.neoskop.de -o yaml > v1alpha1.acme.neoskop.de.yaml
$ kubectl delete apiservice v1alpha1.acme.neoskop.de
$ kubectl create apiservice -f v1alpha1.acme.neoskop.de.yaml
$ kubectl rollout restart deploy/cert-manager-webhook-dnsimple -n cert-manager
```


export NAMESPACE=minios
# check finalizers setting
kubectl get namespaces ${NAMESPACE} -o yaml
# workaround to set finalizers empty
kubectl get namespaces ${NAMESPACE} -o json | jq '.spec.finalizers = []' > /tmp/ns.json
kubectl replace --raw "/api/v1/namespaces/${NAMESPACE}/finalize" -f /tmp/ns.json
# one line command
export NAMESPACE=backend
kubectl get namespaces ${NAMESPACE} -o json | jq '.spec.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/${NAMESPACE}/finalize" -f -
