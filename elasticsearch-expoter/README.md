### Installation
```bash
helm upgrade --install es \
    --namespace infra \
    -f values.yaml \
    -f values.example.yaml \
    stable/elasticsearch-exporter
```

### Patch alerts.rules in [dashboard](https://grafana.com/grafana/dashboards/6483)
```bash
gsed -i -e '/rules/q' values.yaml
gsed -e "/LABELS/s/, value.*//g" \
     -e 's/ALERT/  - alert:/g' \
     -e "s/.*IF/    expr:/g" \
     -e "s/.*FOR/    for:/g" \
     -e "s/.*LABELS { severity=\"alert\"/    labels:\n     severity: critical/g" \
     -e "s/.*LABELS { severity=\"warning\"/    labels:\n     severity: warning/g" \
     -e "s/.*ANNOTATIONS {/    annotations:/" \
     -e "s/.*summary =/      summary:/g" \
     -e "s/.*summary=/      summary:/g" \
     -e "s/.*description =/      description:/g" \
     -e "s/.*description=/      description:/g" \
     -e "s/,$//g" \
     -e "/^  }/d" \
     -e "/^$/d" \
     alerts.rules >> values.yaml
gsed -i -e '/Elastic_UP/,+7 d' \
        -e '/Elasticsearch_health_timed_out/,+7 d' \
        values.yaml
```

### Dashboard
* [6483](https://grafana.com/grafana/dashboards/6483)

### Reference
* [helm chart](https://github.com/helm/charts/tree/master/stable/elasticsearch-exporter)
* [elasticsearch exporter](https://github.com/justwatchcom/elasticsearch_exporter)
* [alertrule](https://awesome-prometheus-alerts.grep.to/rules#elasticsearch)
