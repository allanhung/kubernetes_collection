#!/bin/bash

NS=$1
DEVELOPMENT=$2

kubectl label ns ${NS} istio-injection-
kubectl label ns ${NS} istio-injection=disabled
kubectl get ns ${NS} --show-labels
kubectl rollout restart -n ${NS} deploy ${DEVELOPMENT}
kubectl label ns ${NS} istio-injection-
kubectl label ns ${NS} istio-injection=enabled
