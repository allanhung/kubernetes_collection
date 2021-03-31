## Troubleshooting
### dump components config in default profile
```bash
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path components default
```
### dump base component config and values in default profile
```bash
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path components.base default
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path values.base default
```
### dump pilot component config and values in default profile
```bash
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path components.pilot default
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path values.pilot default
```
### dump ingressGateways component config and values in default profile
```
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path components.ingressGateways default
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path values.gateways.istio-ingressgateway default
```
### sidecar config
```bash
kubectl -n istio-system get configmap istio-sidecar-injector -o=jsonpath='{.data.config}' > inject-config.yaml
kubectl -n istio-system get configmap istio-sidecar-injector -o=jsonpath='{.data.values}' > inject-values.yaml
kubectl -n istio-system get configmap istio -o=jsonpath='{.data.mesh}' > mesh-config.yaml
```
### enable access log in sidecar
```bash
kubectl edit cm istio -n istio-system
  data.mesh.accessLogFile: "/dev/stdout"
  data.mesh.accessLogEncoding: "JSON"
```
### useful field
```
request_id, start_time, downstream_remote_address, downstream_local_address, upstream_local_address, upstream_cluster, upstream_host, response_code, response_flags, route_name
```
### Use EnvoyFilter configuration to selectively enable access logs at gateways
```yaml
kubectl apply -n istio-system -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: gateway-access-log
  namespace: istio-system
spec:
  configPatches:
  - applyTo: NETWORK_FILTER
    match:
      context: GATEWAY
      listener:
        filterChain:
          filter:
            name: "envoy.filters.network.http_connection_manager"
    patch:
      operation: MERGE
      value:
        typed_config:
          "@type": "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
          access_log:
          - name: envoy.access_loggers.file
            typed_config:
              "@type": "type.googleapis.com/envoy.extensions.access_loggers.file.v3.FileAccessLog"
              path: /dev/stdout
              format: "[%START_TIME%] "%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%" %RESPONSE_CODE% %RESPONSE_FLAGS% %BYTES_RECEIVED% %BYTES_SENT% %DURATION% %RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)% "%REQ(X-FORWARDED-FOR)%" "%REQ(USER-AGENT)%" "%REQ(X-REQUEST-ID)%" "%REQ(:AUTHORITY)%" "%UPSTREAM_HOST%"\n"
EOF
```
### Enable Access Logs by EnvoyFilter
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: enable-accesslog
spec:
  workloadSelector:
    labels:
      my-key: my-value
  configPatches:
  - applyTo: NETWORK_FILTER
    match:
      listener:
        filterChain:
          filter:
            name: "envoy.http_connection_manager"
    patch:
      operation: MERGE
      value:
        typed_config:
          "@type": "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
          access_log:
          - name: envoy.access_loggers.file
            typed_config:
              "@type": "type.googleapis.com/envoy.extensions.access_loggers.file.v3.FileAccessLog"
              path: /dev/stdout
              format: "[%START_TIME%] "%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%" %RESPONSE_CODE% %RESPONSE_FLAGS% %BYTES_RECEIVED% %BYTES_SENT% %DURATION% %RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)% "%REQ(X-FORWARDED-FOR)%" "%REQ(USER-AGENT)%" "%REQ(X-REQUEST-ID)%" "%REQ(:AUTHORITY)%" "%UPSTREAM_HOST%"\n"
```
### Log Example
#### Json
```
"{\"authority\": \"%REQ(:AUTHORITY)%\",\"start_time\": \"%START_TIME%\",\"bytes_received\": \"%BYTES_RECEIVED%\",\"bytes_sent\": \"%BYTES_SENT%\",\"downstream_local_address\": \"%DOWNSTREAM_LOCAL_ADDRESS%\",\"downstream_remote_address\": \"%DOWNSTREAM_REMOTE_ADDRESS%\",\"duration\": \"%DURATION%\",\"istio_policy_status\": \"%DYNAMIC_METADATA(istio.mixer:status)%\",\"method\": \"%REQ(:METHOD)%\",\"path\": \"%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%\",\"protocol\": \"%PROTOCOL%\",\"request_id\": \"%REQ(X-REQUEST-ID)%\",\"requested_server_name\": \"%REQUESTED_SERVER_NAME%\",\"response_code\": \"%RESPONSE_CODE%\",\"response_flags\": \"%RESPONSE_FLAGS%\",\"route_name\": \"%ROUTE_NAME%\",\"start_time\": \"%START_TIME%\",\"upstream_cluster\": \"%UPSTREAM_CLUSTER%\",\"upstream_host\": \"%UPSTREAM_HOST%\",\"upstream_local_address\": \"%UPSTREAM_LOCAL_ADDRESS%\",\"upstream_service_time\": \"%RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)%\",\"upstream_transport_failure_reason\": \"%UPSTREAM_TRANSPORT_FAILURE_REASON%\",\"user_agent\": \"%REQ(USER-AGENT)%\",\"x_forwarded_for\": \"%REQ(X-FORWARDED-FOR)%\"}\n"
```
#### Text
```
"[%START_TIME%] "%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%" %RESPONSE_CODE% %RESPONSE_FLAGS% %BYTES_RECEIVED% %BYTES_SENT% %DURATION% %RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)% "%REQ(X-FORWARDED-FOR)%" "%REQ(USER-AGENT)%" "%REQ(X-REQUEST-ID)%" "%REQ(:AUTHORITY)%" "%UPSTREAM_HOST%"\n"
```
* check
```bash
istioctl proxy-config listener <ollies_service_pod_name>.<ollies_service_ns> -o json | grep path -B 1
```
### change logging level in sidecar
```bash
kubectl edit cm -n istio-system istio-sidecar-injector
  proxyLogLevel          values.global.proxy.logLevel
  proxyComponentLogLevel values.global.proxy.componentLogLevel
  log_output_level       values.global.logging.level
```
### change sidecar config
```bash
istioctl proxy-config log <pod-name> --level debug
istioctl proxy-config log <pod-name> --level http:debug
```
### Virtual inbound listener
```bash
istioctl proxy-config listeners <pod-name[.namespace]> --address 0.0.0.0 --port 15006 -o json
```
### Virtual outbound listener
```bash
istioctl proxy-config listeners <pod-name[.namespace]> --address 0.0.0.0 --port 15001 -o json
```
### Outbound listener
```bash
istioctl proxy-config listeners <pod-name[.namespace]> --address 0.0.0.0 --port 80 -o json
```
### All listener
```bash
istioctl proxy-config listeners <pod-name[.namespace]> -o json
```
### envoy 404 NR with nginx proxypass
Nginx is making an outbound request to an ip that is has resolved from your proxypass hostname. This won't work as envoy doesn't know what cluster ip belongs to, so it fails.
#### nginx-ingress
```yaml
  annotations:
    nginx.ingress.kubernetes.io/service-upstream: "true"
```
#### nginx pod
```
proxy_set_header Host xxx;
```

# reference
* [nginx proxypass 404](https://github.com/istio/istio/issues/14450#issuecomment-498771781)
* [envoy debug](https://zhuanlan.zhihu.com/p/258777260)
* [Debugging your debugging tools](https://youtu.be/XAKY24b7XjQ)
* [Enable envoy access logging per pod](https://github.com/istio/istio.io/issues/7613)
* [tracing-and-access-logging](https://github.com/istio/istio/wiki/EnvoyFilter-Samples#tracing-and-access-logging)
