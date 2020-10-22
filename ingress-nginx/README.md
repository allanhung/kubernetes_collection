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

## Reference
[helm chart](https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx)
[nginx ingress configmap](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap)
[nginx ingress annotations](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations)
[dashboard](https://github.com/kubernetes/ingress-nginx/tree/master/deploy)
[Alicloud SLB](https://www.alibabacloud.com/help/doc-detail/86531.htm)
