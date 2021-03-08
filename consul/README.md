## Consul Helm Chart
### Installation
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
kubectl create ns consul
kubectl config set-context --current --namespace=consul
helm upgrade consul hashicorp/consul --install \
    --namespace consul \
    -f values.yaml
kubectl apply -f ingress.yaml -n consul
```

### List Service
```bash
curl http://consul:8500/v1/catalog/services?dc=my-dc
curl http://consul:8500/v1/catalog/service/my-service?ns=my-dc
```

### Register an external service to consul

```bash
# run echo-server
docker run -d --name=es --rm -p 3000:80 ealen/echo-server

# test echo-server
curl http://127.0.0.1:3000

# register service
MYIP=$(ip route get 8.8.8.8 | grep 'src' | awk {'print $NF'})
cat > echo-server.json << EOF
{
  "Node": "my-node",
  "Address": "${MYIP}",
  "NodeMeta": {
    "external-node": "true",
    "external-probe": "true"
  },
  "Service": {
    "ID": "vm-echo-server",
    "Service": "echo-server-in-vm",
    "Port": 3000
  },
  "Checks": [
    {
      "Name": "http-check",
      "status": "passing",
      "Definition": {
        "http": "http://${MYIP}:3000",
        "interval": "30s"
      }
    }
  ]
}
EOF
curl --request PUT --data @echo-server.json http://consul.my-domain.com:8500/v1/catalog/register
```

### Alerts
#### Log
```bash
{app="consul",component="server"} |= "failed to heartbeat"
```

### Reference
* [consul-helm](https://github.com/hashicorp/consul-helm)
* [service-registration-external-services](https://learn.hashicorp.com/tutorials/consul/service-registration-external-services)
