## Installation

### Add helm repo
```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
```
### Install cert manager
```bash
helm upgrade cert-manager jetstack/cert-manager --install \
  --namespace cert-manager \
  --version v1.0.1 \
  --set ingressShim.defaultIssuerName=letsencrypt-issuer \
  --set ingressShim.defaultIssuerKind=ClusterIssuer \
  --set prometheus.servicemonitor.enabled=true \
  --set prometheus.servicemonitor.prometheusInstance=prometheus-operator \
  --set prometheus.servicemonitor.labels.release=po \
  --set extraArgs="{--dns01-recursive-nameservers=8.8.8.8:53,--dns01-recursive-nameservers-only=true}" \
  --set installCRDs=true
```

### Install webhook (AliDns for example)
```bash
# build docker image
git clone https://github.com/allanhung/cert-manager-alidns-webhook
cd cert-manager-alidns-webhook
docker build -t cert-manager-alidns-webhook:my-tag .

# create service account with DNSFullAccess in alicloud   
kubectl create secret generic alidns-secrets --from-literal="access-token=yourtoken" --from-literal="secret-key=yoursecret"i -n cert-manager

# create docker Registry Secret if necessary
kubectl create secret docker-registry my-registry-secret --docker-server=my-docker-registry --docker-username=my-name --docker-password=my-password

helm upgrade cert-manager-webhook-alidns ./alidns-webhook --install \
   --namespace cert-manager \
   --set image.repository=my-docker-registry/cert-manager-alidns-webhook \
   --set image.tag=my-tag \
   --set image.privateRegistry.enabled=true \
   --set image.privateRegistry.dockerRegistrySecret: my-registry-secret
```

### Create Certificate Cluster Issuer
```bash  
kubectl apply -f cert-issuer.yaml
```

### Usage
Append follow annotation in ingress resource.
```yaml
    annotations:
        kubernetes.io/tls-acme: "true" 
```

### Dashboard
* [11001](https://grafana.com/grafana/dashboards/11001)

## References
  - [Securing Ingress Resources](https://cert-manager.io/docs/usage/ingress)
  - [Installation](https://cert-manager.io/docs/installation/kubernetes)
  - [Alidns-webhook](https://github.com/DEVmachine-fr/cert-manager-alidns-webhook)
