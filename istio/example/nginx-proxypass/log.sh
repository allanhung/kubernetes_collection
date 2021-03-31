NGINX_PROXY_POD=$(kubectl get pod -l app=nginx-proxy -o jsonpath="{.items[0].metadata.name}")
kubectl logs $NGINX_PROXY_POD -c istio-proxy --tail 1 -f  | jq '{x_request_id, start_time, downstream_remote_address, downstream_local_address, upstream_local_address, upstream_cluster, upstream_host, response_code, response_flags, route_name, requested_server_name}'
