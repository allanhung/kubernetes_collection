### Enable logging
```bash
kubectl -n istio-system edit cm istio
accessLogFile: "/dev/stdout"
accessLogEncoding: 'JSON'
```
### Create testing resource
```bash
kubectl --context=admin@cluster1 create ns istio-debug
kubectl --context=admin@cluster1 label ns istio-debug istio-injection-
kubectl --context=admin@cluster1 label ns istio-debug istio-injection=enabled
kubectl --context=admin@cluster1 -n istio-debug apply -f curl.yaml -n istio-debug
kubectl --context=admin@cluster1 -n istio-debug apply -f hello-v1.yaml -n istio-debug
kubectl --context=admin@cluster1 -n istio-debug apply -f hello-svc.yaml -n istio-debug

kubectl --context=admin@cluster2 create ns istio-debug
kubectl --context=admin@cluster2 label ns istio-debug istio-injection-
kubectl --context=admin@cluster2 label ns istio-debug istio-injection=enabled
kubectl --context=admin@cluster2 -n istio-debug apply -f curl.yaml
kubectl --context=admin@cluster2 -n istio-debug apply -f hello-v2.yaml
kubectl --context=admin@cluster2 -n istio-debug apply -f hello-svc.yaml
```
### Log
```
kubectl --context=admin@cluster2 -n istio-debug exec -it deploy/curl -- sh
curl helloworld:4000/hello
kubectl --context=admin@cluster2 -n istio-debug logs deploy/curl -c istio-proxy --tail 1 -f  | jq '{request_id, start_time, downstream_remote_address, downstream_local_address, upstream_local_address, upstream_cluster, upstream_host, response_code, response_flags, route_name}'
kubectl --context=admin@cluster1 -n istio-debug logs deploy/helloworld-v1 -c istio-proxy --tail 1 -f  | jq '{request_id, start_time, downstream_remote_address, downstream_local_address, upstream_local_address, upstream_cluster, upstream_host, response_code, response_flags, route_name}'
kubectl --context=admin@cluster2 -n istio-debug logs deploy/helloworld-v2 -c istio-proxy --tail 1 -f  | jq '{request_id, start_time, downstream_remote_address, downstream_local_address, upstream_local_address, upstream_cluster, upstream_host, response_code, response_flags, route_name}'
```
### debug
```bash
export ROUTENAME=$(istioctl --context=admin@cluster2 -n istio-debug proxy-config listeners deploy/curl --address 0.0.0.0 --port 4000 -o json | jq -r '.[0].filterChains[0].filters[0].typedConfig.rds.routeConfigName')
export CLUSTERNAME=$(istioctl --context=admin@cluster2 -n istio-debug proxy-config routes deploy/curl --name ${ROUTENAME} -o json | jq -r '.[0].virtualHosts[1].routes[0].route.cluster')
export SERVICENAME=$(istioctl --context=admin@cluster2 -n istio-debug proxy-config cluster deploy/curl --fqdn ${CLUSTERNAME} -o json | jq -r '.[0].edsClusterConfig.serviceName')
istioctl --context=admin@cluster2 -n istio-debug proxy-config endpoints deploy/curl --cluster ${CLUSTERNAME}
```
```bash
istioctl --context=admin@cluster2 -n istio-debug proxy-config listeners deploy/curl |grep helloworld 
istioctl --context=admin@cluster2 -n istio-debug proxy-config endpoints deploy/curl --cluster 'outbound|80||helloworld.istio-debug.svc.cluster.local'
```

### Reference
* [istio debug data plane](https://www.servicemesher.com/blog/istio-debug-with-envoy-log/)
* [Verify the installation](https://istio.io/latest/docs/setup/install/multicluster/verify/)
