### Upgrade / Install
```bash
helm upgrade --install argo-access \
  -n argo-workflows \
  --create-namespace \
  --set env=example \
  -f values.yaml \
  ./
```

### Create namespace for argo-workflow
* create namespace with label `argo-workflow: enabled`, system will create service account and artifact secret in the namespace
