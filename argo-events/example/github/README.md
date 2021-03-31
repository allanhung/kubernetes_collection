### Upgrade / Installi Github ci/cd
```bash
helm upgrade --install ci-cd \
  -n ci-cd \
  --create-namespace \
  -f ./values.yaml \
  -f ./values.example.yaml \
  ./
```
