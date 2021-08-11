### Simulate istio-init
```bash
docker run -d --rm --name=test-istio --privileged q--entrypoint=tail istio/proxyv2:1.9.0 -f /dev/null
docker exec -ti test-istio bash
/usr/local/bin/pilot-agent istio-iptables -p 15001 -z 15006 -u 1337 -m REDIRECT -i '*' -x "" -b '*' -d 15090,15021,15020
```

### Reference
* [Istio init container crash](https://github.com/istio/istio/issues/24148)
* [istio-init crash](https://imroc.cc/post/202106/isito-init-crash/)

