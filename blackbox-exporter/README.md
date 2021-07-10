### Build blackbox with json support
```bash
docker build --build-arg BLACKBOX_VERSIONTAG=v0.19.0 -t allanhung/blackbox-exporter:v0.19.0 .
```

### Installation
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm upgrade --install blackbox-exporter \
    --namespace monitoring  \
    -f values.yaml \
    -f values.json.yaml \
    -f values.example.yaml \
    prometheus-community/prometheus-blackbox-exporter
```        

### Json response support
#### configuration
<http_probe>
```yaml
  # Probe fails if response body parsed by JSONPath matches setting values.
  fail_if_body_matches_json:
    [ - <JSONPath>=<value>, ... ]
  # Probe fails if response body parsed by JSONPath matches setting values.
  fail_if_body_not_matches_json:
    [ - <JSONPath>=<value>, ... ]
```

#### example
```yaml
modules:
  http_2xx:
    prober: http
    http:
      fail_if_body_not_matches_json:
      - '{.status}=green'
```

### Debug
```bash
curl http://blackbox-exporter-prometheus-blackbox-exporter.monitoring.svc:9115/probe\?module\=http_2xx\&target\=http:%2F%2Fexample.com\&debug\=true
```

### Dashboard
* [7587](https://grafana.com/grafana/dashboards/7587)

### Reference
* [blackbox-exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-blackbox-exporter)
* [alertrule](https://awesome-prometheus-alerts.grep.to/rules#blackbox)
* [blackbox-exporter-configuration](https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md#blackbox-exporter-configuration)
