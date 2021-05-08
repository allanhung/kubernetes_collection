### Prerequisites
```bash
helm repo add fairwinds-stable https://charts.fairwinds.com/stable
helm repo update
``` 

### Upgrade / Install
```bash 
helm upgrade --install polaris
  -n polaris \
  --create-namespace \
  -f ${DIR}/values.yaml \
  fairwinds-stable/polaris
```

### Polaris Webhook
The Polaris webhook provides a way to enforce standards in all of your Kubernetes deployments. Once you have addressed all the misconfigurations identified in the Polaris dashboard, you can deploy the webhook to ensure that the configuration never slips below the configured standard. Once you deploy it in the cluster, the webhook will prevent any further Kubernetes deployment that doesn't meet the configuration standard.

### Reference:
* [Polaris](https://github.com/FairwindsOps/polaris)
* [Polaris helm Chart](https://github.com/FairwindsOps/charts/tree/master/stable/polaris)
* [Setting up polaris on kubernetes](https://www.civo.com/learn/setting-up-polaris-on-k8s)
* [Kubernetes Scanner](https://geekflare.com/kubernetes-security-scanner)
