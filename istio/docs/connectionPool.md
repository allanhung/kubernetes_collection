### trafficPolicy
```yaml
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: connectionPool
  namespace: istio-system
spec:
  host: "*.svc.cluster.local"
  trafficPolicy:
    connectionPool:
      http:
        idleTimeout: 1s
        maxRequestsPerConnection: 1
      tcp:
        tcpKeepalive:
          time: 1s
          interval: 10s
```
### tcp config
```yaml
 apiVersion: networking.istio.io/v1alpha3
 kind: EnvoyFilter
 metadata:
   name: tcp-config
   namespace: istio-system
 spec:
   configPatches:
   - applyTo: CLUSTER
     match:
       context: ANY
     patch:
       operation: MERGE
       value:
         tcp_keepalive:
           keepalive_time: 1
           keepalive_interval: 10
```           
