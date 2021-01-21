# kubernetes package collection

## blackbox-exporter
## cert-manager
## cluster-autoscaler
## consul
## consul-exporter
## debug
## dex-gangway-oidc
## echo-server
## elasticsearch-expoter
## external-dns
## fluent-bit-loki
## hpa
## ingress-nginx
## jmx-exporter
## kafka-exporter
## linkerd
## loki-stack
## mysql-exporter
## nginx
## postgresql
## prometheus-adapter
## prometheus-msteams
## prometheus-operator
## rabbitmq
## rabbitmq-exporter
## redis-exporter
## regsecret-operator
## spark-operator
## statsd-exporter
## vault
## vault-exporter
## vault-secrets-webhook
## virtual-kubelet-alicloud

# Update to new repo
* stable:
  * old repo: https://kubernetes-charts.storage.googleapis.com
  * new repo: https://charts.helm.sh/stable

* incubator
  * old repo: https://kubernetes-charts-incubator.storage.googleapis.com
  * new repo: https://charts.helm.sh/incubator

```bash
helm repo rm stable
helm repo add stable https://charts.helm.sh/stable
helm repo rm incubator
helm repo add incubator https://charts.helm.sh/incubator
```

# Reference
[relocate charts to new repos](https://github.com/helm/charts/issues/21103)
