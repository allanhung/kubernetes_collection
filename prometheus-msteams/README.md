### Installation
```bash
helm repo add prometheus-msteams https://prometheus-msteams.github.io/helm-chart/
helm repo update

helm upgrade --install \
  prometheus-msteams \
  --namespace infra \
  -f values.yaml \
  --set-file customCardTemplate=default-message-card.tmpl \
  prometheus-msteams/prometheus-msteams
```        

### Test teams channel
```bash
curl -H 'Content-Type: application/json' -d '{"text": "Test Message"}' <YOUR WEBHOOK URL>
```

### Reference
* [prometheus-msteams](https://github.com/prometheus-msteams/prometheus-msteams)
