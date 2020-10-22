## Installation

### Install cert manager
```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm upgrade cert-manager jetstack/cert-manager --install \
  --namespace cert-manager \
  -f values.yaml
```

### Install webhook (AliDns)
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

### Install webhook (DNSimple)
```bash
helm repo add neoskop https://charts.neoskop.dev
helm repo update
helm upgrade cert-manager-webhook-dnsimple -install \
  --namespace cert-manager \
  --set dnsimple.account=my-dnsimple-account \
  --set dnsimple.token=my-dnsimple-token \
  --set certManager.namespace=cert-manager \
  neoskop/cert-manager-webhook-dnsimple
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
* [cert-manager helm chart](https://github.com/jetstack/cert-manager/tree/master/deploy)
* [dnsimple webhook](https://github.com/neoskop/cert-manager-webhook-dnsimple)
* [Securing Ingress Resources](https://cert-manager.io/docs/usage/ingress)
* [Installation](https://cert-manager.io/docs/installation/kubernetes)
* [Alidns-webhook](https://github.com/DEVmachine-fr/cert-manager-alidns-webhook)
