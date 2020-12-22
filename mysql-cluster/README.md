### Installation
```bash
helm repo add presslabs https://presslabs.github.io/charts
helm repo update

helm upgrade --install mycluster-example \
    --namespace mycluster \
    --create-namespace \
    -f values.yaml \
    presslabs/mysql-cluster
```

### Stop for troubleshooting
change replicas to 0 to termiate all mysql. This will only keep 1 pvc.
```bash
kubectl patch mysqlcluster mycluster-example -n mycluster -p '{"spec":{"replicas": 0}}'
```

### Re-Initialize from master
```bash
kubectl -n mycluster patch service mycluster-example-master --record --type='json' -p='[
  {
    "op": "add",
    "path": "/spec/ports/1",
    "value": {
              "name": "sidecar",
              "port": 8080,
              "protocol": "TCP",
              "targetPort": 8080
             }
  }
]'
```
```bash
kubectl -n mycluster get service mycluster-example-master -o yaml | gsed -e 's/mycluster-example-master/mycluster-example-replicas/g' -e 's/3306/8080/g' > mycluster-example-replicas.yaml
kubectl apply -f mycluster-example-replicas.yaml
```

### Reference
* [deploy mysql cluster](https://github.com/presslabs/mysql-operator/blob/master/docs/deploy-mysql-cluster.md)
* [Integrating mysql clusters into your own helm charts](https://github.com/presslabs/mysql-operator/blob/master/docs/integrate-operator.md)
