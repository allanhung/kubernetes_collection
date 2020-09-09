# Debug
    
### Transfer kustomize to helm
```bash
mkdir -p chart/templates
docker run -v ${PWD}:/working kustomize-helm-plugins kustomize/overlays/helm > chart/templates/all.yaml
chart/nodeSelector.sh
```
### Installation with kustomize
```bash
kustomize build kustomize/base | kubectl apply -f -
```
### Installation with Helm
```bash
kubectl create ns debug
# You can specify nodeSelector in chart/values.yaml to run on particular node.
helm upgrade debug chart/ --install --namespace debug -f chart/values.yaml
```

### Reference
  - [kustomize-helm-plugins](https://github.com/allanhung/kustomize-helm-plugins)
