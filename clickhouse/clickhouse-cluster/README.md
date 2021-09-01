# Helm Chart for ClickHouse Cluster

## Pre-requirement
Before install ClickHouse cluster, you should install [ClickHouse-Operator](../clickhouse-operator/README.md) first.

## Installation
```bash
helm upgrade --install ch-cluster \
  --namespace clickhouse \
  --create-namespace \
  -f values.yaml \
  ./
```
For a list of all configurable options and variables see [values.yaml](values.yaml).
