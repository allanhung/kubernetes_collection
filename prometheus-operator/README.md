### Installation
```bash
helm upgrade --install po \
    --namespace monitoring  \
    -f values.yaml \
    -f values.example.yaml \
    stable/prometheus-operator
```        
