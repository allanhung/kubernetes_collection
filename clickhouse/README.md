[ClickHouse](https://clickhouse.tech/) is an open source column-oriented database management system capable of real time generation of analytical data reports using
SQL queries.

This repository provides a helm chart for easily setting up a ClickHouse cluster in Kubernetes.

### Clickhouse client
* python client
```bash
dnf install -y python3-pip
pip3 install clickhouse-cli
```
* [tabix](https://tabix.io/)

### Reference
* [clickhouse-operator](https://github.com/Altinity/clickhouse-operator)
* [zookeeper](https://github.com/bitnami/charts/tree/master/bitnami/zookeeper)
* [zoonavigator](https://github.com/Lowess/helm-charts)
* [charts-clickhouse](https://github.com/PostHog/charts-clickhouse)
