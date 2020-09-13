## Linkerd Helm Chart
### Installation
```bash
helm repo add ealenn https://ealenn.github.io/charts
helm repo update
kubectl create ns linkerd
helm upgrade l5d stable/linkerd --install \
  --namespace linkerd \
  -f values.yaml

helm upgrade echo-server ealenn/echo-server --install \
```

### Reference
* [linkerd](https://github.com/linkerd/linkerd)
* [kubectl](https://github.com/BuoyantIO/kubectl)

### Resource for linkerd
* [linkerd documentation](https://linkerd.io/1/)
* [linkerd configuration](https://api.linkerd.io/head/linkerd/index.html#introduction)
* [Routing](https://linkerd.io/1/advanced/routing)
* [rewriting-namers](https://api.linkerd.io/head/linkerd/index.html#rewriting-namers)
* [Transparent TLS with Linkerd](https://linkerd.io/2016/03/24/transparent-tls-with-linkerd)
* [dTab examples](https://github.com/linkerd/linkerd/issues/320)
* [Linkerd Routing explained](https://medium.com/@fmataraci6/linkerd-routing-explained-linkerd-1-1a880d696c51)
