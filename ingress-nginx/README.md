### Installation
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install nginx-internal \
    --namespace kube-system \
    -f values.yaml \
    -f values.ali.yaml \
    --set controller.ingressClass=nginx-internal-test \
    ingress-nginx/ingress-nginx
```        

### Dashboard
* [9614](https://grafana.com/grafana/dashboards/9614)

### externalTrafficPolicy
Cluster: can't get the real client ip from the log.
Local: some pods can't reach the slb ip address.

### Connection refused issue
Need to patch service target port from name to number
```bash
kubectl describe svc xxx 
....
Type:                     LoadBalancer
IP:                       xxxx
LoadBalancer Ingress:     xxxx
Port:                     http  80/TCP
TargetPort:               http/TCP
NodePort:                 http  30683/TCP
....
Events:
  Type     Reason              Age                   From                Message
  ----     ------              ----                  ----                -------
  Normal   ServiceSpecChanged  2m29s (x2 over 34m)   service-controller  The service will be updated because the spec has been changed.
  Warning  Failed              109s (x246 over 63m)  service-controller  Fail to ensure loadbalancer, error Message: The specified Port must be between 1 and 65535.. k8s/0/echo-server/debug/c22d473d33fed4328a89602bdb857032f
```

## Reference
[helm chart](https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx)
[nginx ingress configmap](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap)
[nginx ingress annotations](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations)
[dashboard](https://github.com/kubernetes/ingress-nginx/tree/master/deploy)
[Alicloud SLB](https://www.alibabacloud.com/help/doc-detail/86531.htm)
[Ingress Controller Name](https://github.com/kubernetes/ingress-nginx/blob/master/internal/k8s/main.go)
[IngressClass](https://github.com/kubernetes/ingress-nginx/issues/5593#issuecomment-721562875)
[Ingress Class not work](https://github.com/nginxinc/kubernetes-ingress/issues/1283#issuecomment-746701219)
[Nginx Opentracing](https://github.com/opentracing-contrib/nginx-opentracing)
[NGINX Ingress Controller - Opentracing](https://kubernetes.github.io/ingress-nginx/user-guide/third-party-addons/opentracing/)
