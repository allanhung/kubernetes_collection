### Error Message
```json
{"message": "pika.adapters.utils.connection_workflow._report_completion_and_cleanup AMQPConnector - reporting failure: AMQPConnectorAMQPHandshakeError: IncompatibleProtocolError: The protocol returned by the server is not supported: ('StreamLostError: (\"Stream connection lost: error(104, \\'Connection reset by peer\\')\",)',)"
```
#### Disable mtls with label selector (need to disable in client side)
```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: disable-mtls
  namespace: default
spec:
  selector:
    matchLabels:
      app: mtls-disable
  mtls:
    mode: DISABLE
```
#### Disable mtls with DestinationRule
```yaml
apiVersion: "networking.istio.io/v1alpha3"
kind: "DestinationRule"
metadata:
  name: "disable-mtls"
  namespace: "bookinfo"
spec:
  host: "*.bookinfo.svc.cluster.local"
    trafficPolicy:
      tls:
        mode: DISABLE
```
### Reference
* [peer_authentication](https://istio.io/latest/docs/reference/config/security/peer_authentication)
* [disable mtls](https://itnext.io/istio-adventures-disabling-mtls-for-one-namespace-62f37b99855c)
