#!/usr/bin/env bash

SEVERITY=${1:-warning}
CLUSTER=${2:-test_cluster}
ENV=${3:-test_env}
INSTANCENUM=${4:-1}
STATUS=${5:-firing} # firing or resolved
KEY=${6:-date}
VALUE=${7:-`date +"%H%M%S"`}
ENDDATE=$(TZ=UTC date -d -10mins +"%FT%T.%3NZ")
ENDSAT=""
if [  "$STATUS"  =  "resolved"  ]; then
  ENDSAT=`echo -e ",\n     \"endsAt\": \"$ENDDATE\""`
fi

alerts1='[
  {
    "status": "'$STATUS'",
    "labels": {
       "alertname": "Test Alert",
       "cluster": "'$CLUSTER'",
       "env": "'$ENV'",       
       "instance": "test_instance_'$INSTANCENUM'",
       "severity": "'$SEVERITY'"
     },
     "annotations": {
       "title": "Test Alert",
       "description": "Test Description",
       "'$KEY'": "'$VALUE'"
     }'$ENDSAT'
  }
]'
curl -XPOST -d"$alerts1" http://po-kube-prometheus-stack-alertmanager:9093/api/v1/alerts
echo -e "\nresolved alert: $0 $SEVERITY $CLUSTER $ENV $INSTANCENUM resolved $KEY $VALUE"
