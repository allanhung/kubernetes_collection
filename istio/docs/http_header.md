### Trace log
```bash
kubectl exec -it pod/<POD> -- curl -X POST localhost:15000/logging?http=trace
```
#### Log with duplicate headers
```
2020-06-23T21:40:36.631195Z trace envoy http [external/envoy/source/common/http/http1/codec_impl.cc:433] [C528] completed header: key=transfer-encoding value=chunked
...
2020-06-23T21:40:36.631207Z trace envoy http [external/envoy/source/common/http/http1/codec_impl.cc:433] [C528] completed header: key=Transfer-Encoding value=chunked
```
#### Solution
We enabled further debugging, and found that the backend, our service is interacting with is returning this header and our application is setting these headers and returning the response. We modified our code to delete transfer-encoding header, and see the issue is not happening.

### Test
```bash
curl -X POST -H  "Content-Type: application/json" -H "transfer-encoding: chunked"  -H "content-length: 600"  http://my-service.mydomain.com/my-api -d '{"my-key":"my-values"}'
```

### Reference
* [Envoy Proxy disconnects](https://github.com/istio/istio/issues/24753#issuecomment-651322955)
* [allow duplicated chunked header](https://github.com/envoyproxy/envoy/pull/11916#discussion_r451055005)
* [Transfer encoding issues](https://github.com/istio/istio/issues/28433)
* [Websocket traffic fails](https://github.com/istio/istio/issues/29427#issuecomment-781550817)
