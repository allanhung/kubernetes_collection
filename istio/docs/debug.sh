#!/bin/bash

SOURCEPOD=$1
SOURCENS=$2
TARGETPOD=$3
TARGETNS=$4
TEST_COMMAND=$5

# change logging level
kubectl exec -it ${SOURCEPOD} -n ${SOURCENS} -- curl -X POST localhost:15000/logging?http=trace
#kubectl exec -it ${SOURCEPOD} -n ${SOURCENS} -- curl -X POST localhost:15000/logging?upstream=trace
kubectl exec -it ${TARGETPOD} -n ${TARGETNS} -- curl -X POST localhost:15000/logging?http=trace
#kubectl exec -it ${TARGETPOD} -n ${TARGETNS} -- curl -X POST localhost:15000/logging?upstream=debug
# save log
cat /dev/null > /tmp/source_proxy.log
sh -c "kubectl logs -n ${SOURCENS} ${SOURCEPOD} -c istio-proxy --tail=1 -f | tee /tmp/source_proxy.log" &
cat /dev/null > /tmp/target_proxy.log
sh -c "kubectl logs -n ${TARGETNS} ${TARGETPOD} -c istio-proxy --tail=1 -f | tee /tmp/target_proxy.log" &
# run test command
kubectl exec -it ${SOURCEPOD} -n ${SOURCENS} -- ${TEST_COMMAND}
# kill logging process
kill $(ps aux |grep "kubectl logs"| grep -v grep |awk {'print $2'})
# change logging level
kubectl exec -it ${SOURCEPOD} -n ${SOURCENS} -- curl -X POST localhost:15000/logging?http=warning
#kubectl exec -it ${SOURCEPOD} -n ${SOURCENS} -- curl -X POST localhost:15000/logging?upstream=warning
kubectl exec -it ${TARGETPOD} -n ${TARGETNS} -- curl -X POST localhost:15000/logging?http=warning
#kubectl exec -it ${TARGETPOD} -n ${TARGETNS} -- curl -X POST localhost:15000/logging?upstream=warning
# config dump
kubectl exec -it ${TARGETPOD} -n ${TARGETNS} -- curl -X POST localhost:15000/config_dump > /tmp/proxy_config
