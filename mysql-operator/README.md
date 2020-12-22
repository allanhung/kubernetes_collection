### Installation
```bash
helm repo add presslabs https://presslabs.github.io/charts
helm repo update

helm upgrade --install mysql-operator \
    --namespace mysql-operator \
    --create-namespace \
    -f values.yaml \
    -f values.example.yaml \
    presslabs/mysql-operator
```

### Reference
* [Getting started](https://github.com/presslabs/mysql-operator/blob/master/docs/_index.md)
