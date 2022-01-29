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

### Service Port Patch
```bash
helm pull ingress-nginx/ingress-nginx --version 3.40.0 --untar
patch -p1 < port.patch

helm upgrade --install nginx \
    --namespace infra \
    --create-namespace \
    --version 3.40.0 \
    -f ./values.yaml \
    ./ingress-nginx

rm -rf ./ingress-nginx
```

### UDP Patch
```bash
helm pull ingress-nginx/ingress-nginx --version 3.40.0 --untar
patch -p1 < udp.patch

helm upgrade --install nginx \
    --namespace infra \
    --create-namespace \
    --version 3.40.0 \
    -f ./values.yaml \
    ./ingress-nginx

rm -rf ./ingress-nginx
```

### Fail to ensure loadbalancer, error Message: The specified Port must be between 1 and 65535..
* In some cloud provider, it could only use the number as port and target port.
```bash
helm pull ingress-nginx/ingress-nginx --version 3.36.0 --untar
patch -p1 < port.patch

helm upgrade --install nginx \
    --namespace infra \
    --create-namespace \
    --version 3.36.0 \
    -f ./values.yaml \
    ./ingress-nginx

rm -rf ./ingress-nginx
```

### modsecurity
#### check version in pod
```bash
ls -l /usr/local/modsecurity/lib/
```
config example:
* configmap
```yaml
kind: ConfigMap
data:
  enable-modsecurity: "true"
  modsecurity-snippet: |
    SecAuditLog /dev/stdout
    SecAuditLogFormat JSON
    SecDebugLog /var/log/modsec_debug.log
    SecDebugLogLevel 0
    SecRuleRemoveById 920350
    SecRequestBodyAccess Off
    SecRequestBodyLimitAction ProcessPartial
    SecRule REQUEST_FILENAME "@rx /api/networks/[0-9]+/state$" \
      "id:9002201,\
      phase:2,\
      nolog,\
      pass,\
      ctl:ruleRemoveById=913120,\
      ctl:ruleRemoveById=942410,\
      ctl:ruleRemoveById=932110;"
```
* annotations
```yaml
annotations:
  nginx.ingress.kubernetes.io/modsecurity-snippet:
    SecRuleEngine On
```


### externalTrafficPolicy
* Cluster: can't get the real client ip from the log.
* Local: some pods can't reach the slb ip address.

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
[ModSecurity](https://github.com/SpiderLabs/ModSecurity)
[OWASP ModSecurity Core Rule Set (CRS)](https://github.com/coreruleset/coreruleset)
[modsecurity issue 4902](https://github.com/kubernetes/ingress-nginx/issues/4902)
[modsecurity doc](https://github.com/kubernetes/ingress-nginx/blob/main/docs/user-guide/third-party-addons/modsecurity.md)
[Processing phases of Modsecurity](https://malware.expert/modsecurity/processing-phases-modsecurity/)
[SecRequestBodyAccess off skips the phase:2 rules](https://github.com/SpiderLabs/ModSecurity/issues/2465)
[ModSecurity 3 Leads to Complete Bypass](https://coreruleset.org/20210302/disabling-request-body-access-in-modsecurity-3-leads-to-complete-bypass/)
[Json Support](https://www.trustwave.com/en-us/resources/blogs/spiderlabs-blog/modsecurity-advanced-topic-of-the-week-json-support/)
