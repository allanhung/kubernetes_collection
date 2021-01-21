### Installation
* Get gangway.clientID, gangway.clientSecret from dex, set in values.example.yaml

```bash
kubectl -n dex get configmap gangway-template && kubectl -n dex delete configmap gangway-template || echo "configmap not exists"
kubectl -n dex create configmap gangway-template --from-file=home.tmpl --from-file=commandline.tmpl

helm upgrade --install gangway stable/gangway \
    --namespace dex \
    -f values.yaml \
    -f values.example.yaml
``` 

### Origin template
```bash
curl -LO https://raw.githubusercontent.com/heptiolabs/gangway/master/templates/commandline.tmpl
curl -LO https://raw.githubusercontent.com/heptiolabs/gangway/master/templates/home.tmpl
```

### Reference
[helm charts](https://github.com/helm/charts)
