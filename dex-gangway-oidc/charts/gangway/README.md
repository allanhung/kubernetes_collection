## Quid 

### Installation
* Get gangway.clientID, gangway.clientSecret from dex, set in values.example.yaml

```

helm upgrade --install gangway stable/gangway \
    --namespace infra \
    -f values.yaml \
    -f values.example.yaml
``` 
