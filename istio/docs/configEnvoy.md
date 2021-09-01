### Issue
#### enable proxy tracing
```bash
kubectl exec -it ${POD} -- curl -X POST localhost:15000/logging?http=trace
```
#### get error message
```
dispatch error: http/1.1 protocol error: both 'Content-Length' and 'Transfer-Encoding' are set.
```
### solution
```
remove the Content-Length header
```

### Workaround
### Config envoy through EnvoyFilter
#### Networkfilter
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: allow-chunked-length
  namespace: istio-system
spec:
  configPatches:
  - applyTo: NETWORK_FILTER
    match:
      listener:
        filterChain:
          filter:
            name: "envoy.filters.network.http_connection_manager"
    patch:
      operation: MERGE
      value:
        typed_config:
          "@type": "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
          http_protocol_options:
            allow_chunked_length: true
```
#### Cluster
This might get stale state with CDS when issue `istioctl proxy-status`.
That might cause by [envoy](https://github.com/envoyproxy/envoy/blob/main/source/common/upstream/upstream_impl.cc#L704-L710).
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: envoy-filter-developer-ui
  namespace: istio-system
spec:
  configPatches:
  - applyTo: CLUSTER
    match:
      context: ANY
    patch:
      operation: MERGE
      value:
        http_protocol_options:
          allow_chunked_length: true
```

#### dump config
```bash
kubectl exec -it ${POD} -- curl -X POST localhost:15000/config_dump
```

#### Verify envoy version
```bash
kubectl exec -it ${POD} -c istio-proxy  -- pilot-agent request GET server_info --log_as_json | jq {version}
```

### Reference
* [envoy filter](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/filter/filter)
* [rfc7230](https://datatracker.ietf.org/doc/html/rfc7230#section-3.3.3)
* [issue 14004](https://github.com/envoyproxy/envoy/issues/14004)
* [Allow requests with Transfer-Encoding and Content-Length](https://github.com/envoyproxy/envoy/pull/12349)
* [envoy http1protocoloptions](https://www.envoyproxy.io/docs/envoy/latest/api-v3/config/core/v3/protocol.proto#config-core-v3-http1protocoloptions)
* [add support for preserving header key case](https://github.com/istio/istio/pull/33030)
