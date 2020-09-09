# External DNS
    
### Transfer kustomize to helm
```bash
mkdir -p chart/templates
docker run -v ${PWD}:/working kustomize-helm-plugins kustomize/overlays/helm > chart/templates/all.yaml
```
### Installation with kustomize
```bash
kustomize build kustomize/overlays/${example} | kubectl apply -f -
```
### Installation with Helm
```bash
kubectl create ns external-dns
helm upgrade external-dns chart/ --install --namespace external-dns -f chart/values.yaml
```

### Reference
  - [kustomize-helm-plugins](https://github.com/allanhung/kustomize-helm-plugins)
  - [external-dns](https://github.com/kubernetes-sigs/external-dns)
