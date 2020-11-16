### Installation
```bash
git clone --depth 1 https://github.com/prometheus-community/helm-charts
patch -p1 < servicemonitor.patch

helm upgrade --install rabbitmq-exporter \
    --namespace monitoring  \
    -f values.yaml \
    -f values.example.yaml \
    prometheus-community/prometheus-rabbitmq-exporter

rm -rf ./helm-charts
```        

### create monitoring user
```bash
rabbitmqctl add_user exporter my-password
rabbitmqctl set_user_tags exporter monitoring
rabbitmqctl set_permissions --vhost / exporter "" "" ""
```

### check
#### list user
```bash
rabbitmqctl list_users
```
#### test account
```bash
curl -u exporter:my-password http://my-rabbitmq:15672/api/whoami
```
#### download admin cli
```bash
curl -u admin:my-password http://my-rabbitmq:15672/cli/rabbitmqadmin > rabbitmqadmin.py
```
#### create queue
```bash
./rabbitmqadmin.py -u user -p my-password -H my-rabbitmq declare queue name=test durable=false
```
#### list queue
```bash
./rabbitmqadmin.py -u user -p my-password -H my-rabbitmq list queues
```
#### publish
```bash
./rabbitmqadmin.py -u user -p my-password -H my-rabbitmq publish exchange=amq.default routing_key=test payload="hello, world"
```
#### consume
```bash
./rabbitmqadmin.py -u user -p my-password -H my-rabbitmq get queue=test ackmode=ack_requeue_false
```
#### test api
```
curl -u exporter:my-password http://my-rabbitmq:15672/api/exchange
curl -u exporter:my-password http://my-rabbitmq:15672/api/overview
curl -u exporter:my-password http://my-rabbitmq:15672/api/nodes
curl -u exporter:my-password http://my-rabbitmq:15672/api/nodes/{node}
curl -u exporter:my-password http://my-rabbitmq:15672/api/queues/{vhost}/{qname}
```
### Dashboard
* [4279](https://grafana.com/grafana/dashboards/4279)
* [4371](https://grafana.com/grafana/dashboards/4371)
* [10863](https://grafana.com/grafana/dashboards/10863)

### Reference
* [rabbitmq-exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-rabbitmq-exporter)
* [alertrule](https://awesome-prometheus-alerts.grep.to/rules#rabbitmq-(official-exporter)
