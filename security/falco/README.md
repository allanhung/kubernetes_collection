### Installation
```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts

helm upgrade --install falco \
  --namespace security \
  -f values.yaml \
  falcosecurity/falco
```

### Reference
* [charts](https://github.com/falcosecurity/charts)
* [falco](https://github.com/falcosecurity/falco)
* [falco-exporter](https://github.com/falcosecurity/falco-exporter)
* [falcosidekick](https://github.com/falcosecurity/falcosidekick)
