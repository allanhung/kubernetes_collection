### Example
```bash
kubectl auth can-i create customresourcedefinitions --all-namespaces --as system:serviceaccount:infra:kes-kubernetes-external-secrets
kubectl auth can-i create customresourcedefinitions/externalsecrets.kubernetes-client.io --all-namespaces --as system:serviceaccount:infra:kes-kubernetes-external-secrets
```
