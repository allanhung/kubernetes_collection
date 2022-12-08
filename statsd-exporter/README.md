### Installation
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install statsd-exporter \
    --namespace infra  \
    --create-namespace \
    -f values.yaml \
    -f values.vault.yaml \
    prometheus-community/prometheus-statsd-exporter
```        

### Debug
```bash
# server
curl -LO https://github.com/prometheus/statsd_exporter/releases/download/v0.22.4/statsd_exporter-0.22.4.darwin-amd64.tar.gz
tar -zxf statsd_exporter-0.22.4.darwin-amd64.tar.gz
rm -f statsd_exporter-0.22.4.darwin-amd64.tar.gz
cat > mapping.yaml << EOF
mappings:
- match: "(.*)\\\\_counter"
  match_type: regex
  name: "\${1}_count"
  ttl: 0
- match: "(.*)"
  match_type: regex
  name: "\${1}"
  ttl: 5s
EOF
./statsd_exporter-0.22.4.darwin-amd64/statsd_exporter --statsd.mapping-config=mapping.yaml --log.level=debug
# clinet
docker run -d --rm --name=statsd_client rockylinux tail -f /dev/null
echo "test_end_with_timestamp:1|g" | nc -w 1 -u prom-statsd 9125
curl http://prom-statsd:9102/metrics |grep test_end_with_timestamp
curl 'http://po-kube-prometheus-stack-prometheus:9090/api/v1/query?query=test_end_with_timestamp[5m]'
curl 'http://po-kube-prometheus-stack-prometheus:9090/api/v1/query?query=test_end_with_timestamp[5m]&time=2022-05-31T02:35:00.000Z'
```

### Reference
* [statsd-exporter](https://github.com/prometheus/statsd_exporter)
* [statsd-exporter helm chart](https://github.com/niclic/helm-charts)
* [vault-monitoring](https://coreos.com/tectonic/docs/latest/vault-operator/user/monitoring.html)
* [vault-mapping](https://gist.github.com/tam7t/64291f4ebbc1c45a1fc876b6c0613221)
* [vault-exporter](https://github.com/kubevault/vault_exporter)
* [Forward DogStatsD Metrics to Prometheus](https://marselester.com/prometheus-via-dogstatsd.html)
* [mapping ttl](https://github.com/prometheus/statsd_exporter/blob/master/pkg/mapper/mapper.go#L228-L229)
* [timed-decorator](https://github.com/prometheus/statsd_exporter#timed-decorator)
