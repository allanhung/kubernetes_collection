### Enable logging
```bash
kubectl -n istio-system edit cm istio
accessLogFile: "/dev/stdout"
accessLogEncoding: 'JSON'
```
### Create testing resource
```bash
kubectl apply -f curl.yaml
kubectl apply -f hello-v1.yaml
kubectl apply -f hello-v2.yaml
kubectl apply -f hello-svc.yaml
```
### Log
```
CURL_POD=$(kubectl get pod -l app=curl -o jsonpath="{.items[0].metadata.name}")
HELLO_V1_POD=$(kubectl get pod -l app=helloworld -l version=v1 -o jsonpath="{.items[0].metadata.name}")
HELLO_V2_POD=$(kubectl get pod -l app=helloworld -l version=v2 -o jsonpath="{.items[0].metadata.name}")
kubectl exec -it $CURL_POD -c curl -- sh
kubectl logs $CURL_POD -c istio-proxy --tail 1 -f  | jq '{request_id, start_time, downstream_remote_address, downstream_local_address, upstream_local_address, upstream_cluster, upstream_host, response_code, response_flags, route_name}'
kubectl logs $HELLO_V1_POD -c istio-proxy --tail 1 -f  | jq '{request_id, start_time, downstream_remote_address, downstream_local_address, upstream_local_address, upstream_cluster, upstream_host, response_code, response_flags, route_name}'
kubectl logs $HELLO_V2_POD -c istio-proxy --tail 1 -f  | jq '{request_id, start_time, downstream_remote_address, downstream_local_address, upstream_local_address, upstream_cluster, upstream_host, response_code, response_flags, route_name}'
```
### Reference
* [istio debug data plane](https://www.servicemesher.com/blog/istio-debug-with-envoy-log/)
