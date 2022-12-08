### Installation
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install rabbitmq \
    --namespace rabbitmq  \
    -f values.yaml \
    -f values.example.yaml \
    bitnami/rabbitmq
```

### upgrade
retrive origin erlangCookie
```bash
PASSWORDS ERROR: You must provide your current passwords when upgrading the release.
                 Note that even after reinstallation, old credentials may be needed as they may be kept in persistent volume claims.
                 Further information can be obtained at https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues/#credential-errors-while-upgrading-chart-releases

    'auth.erlangCookie' must not be empty, please add '--set auth.erlangCookie=$RABBITMQ_ERLANG_COOKIE' to the command. To get the current value:

export RABBITMQ_ERLANG_COOKIE=$(kubectl get secret rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 --decode)
```

### metrics
```bash
curl http://rabbitmq-rabbitmq:9419/metrics
```

### Dashboard
* [10991](https://grafana.com/grafana/dashboards/10991)

### Reference
* [rabbitmq](https://github.com/bitnami/charts/tree/master/bitnami/rabbitmq)
* [rabbitmq-prometheus](https://github.com/rabbitmq/rabbitmq-prometheus)
* [dashboards](https://github.com/rabbitmq/rabbitmq-prometheus/tree/master/docker/grafana/dashboards)
