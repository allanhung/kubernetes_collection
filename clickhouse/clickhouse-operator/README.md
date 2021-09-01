# Helm Chart for ClickHouse Operator

## Pre-requirement
* get [clickhouse-operator](https://www.github.com/Altinity/clickhouse-operator) update
```bash
./get_update.sh
```

## Installiation
```bash
helm upgrade --install ch-operator \
  --namespace clickhouse \
  --create-namespace \
  -f values.yaml \
  ./
```

