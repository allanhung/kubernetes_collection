#!/bin/bash

echo "retrieve clickhouse-operator version."
VERSION=$(curl --silent "https://api.github.com/repos/Altinity/clickhouse-operator/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo "clickhouse-operator version: ${VERSION}."

echo "downloading clickhouse-operator crd."
curl -L -o crds/crd.yaml https://raw.githubusercontent.com/Altinity/clickhouse-operator/${VERSION}/deploy/operator/clickhouse-operator-install-crd.yaml
echo "downloading clickhouse-operator deployment."
curl -L -o templates/deployment.yaml https://raw.githubusercontent.com/Altinity/clickhouse-operator/${VERSION}/deploy/operator/clickhouse-operator-install-template-deployment.yaml
echo "downloading clickhouse-operator service."
curl -L -o templates/service.yaml https://raw.githubusercontent.com/Altinity/clickhouse-operator/${VERSION}/deploy/operator/clickhouse-operator-install-template-service.yaml
echo "downloading clickhouse-operator rbac."
curl -L -o templates/rbac.yaml https://raw.githubusercontent.com/Altinity/clickhouse-operator/${VERSION}/deploy/operator/clickhouse-operator-install-template-rbac.yaml
echo "update clickhouse-operator chart version to ${VERSION}."
gsed -i -e "s/appVersion:.*/appVersion: ${VERSION}/g" Chart.yaml
gsed -i -e "s/tag:.*/tag: ${VERSION}/g" values.yaml
echo "patch clickhouse-operator."
patch -p1 < clickhouse-operator.patch
