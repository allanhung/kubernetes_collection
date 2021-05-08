#!/usr/bin/env bash

DIR="$(dirname $0 )"
ENV=$1

if [[ -z ${ENV} ]]; then
    echo "Usage: $0 <environment>"
    exit 1
elif [[ ${ENV} == "dev"* ]]; then
    DOMAIN=develop
elif [[ ${ENV} == "dev-canary"* ]]; then
    DOMAIN=develop
elif [[ ${ENV} == "prod"* ]]; then
    DOMAIN=production
fi

echo
echo "# ---------------------------------------------------------------------------------------------------------------"
echo "#  Checking if namespace spark exists."
echo "# ---------------------------------------------------------------------------------------------------------------"
kubectl get ns spark || kubectl create ns spark

echo
echo "# ---------------------------------------------------------------------------------------------------------------"
echo "#  Setting up Spark Operator in ${ENV}."
echo "# ---------------------------------------------------------------------------------------------------------------"

helm upgrade --install spark-operator \
  -n spark-operator \
  --create-namespace \
  -f ${DIR}/values.yaml \
  --set ingressUrlFormat="\{\{\$appName\}\}.${DOMAIN}.in.quid.com" \
  spark-operator/spark-operator

