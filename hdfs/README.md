#### Upgrade / Install
```bash
git clone https://github.com/gchq/gaffer-docker

helm upgrade --install hdfs \
  -n infra \
  --create-namespace \
  -f ./values.yaml \
  -f ./values.example.yaml \
  ./gaffer-docker/kubernetes/hdfs
```

### Reference
* [hdfs helm chart](https://github.com/gchq/gaffer-docker)
