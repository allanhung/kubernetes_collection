## Consul Helm Chart
### Installation
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

helm pull hashicorp/consul --version 0.31.1 --untar && patch -p1 < consul.patch

helm upgrade --install consul \
    --namespace consul \
    --create-namespace \
    ./consul

rm -rf ./consul
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

### Issue
failed inserting node: Error while renaming Node ID: "c9ed3871-a792-a15d-4a01-d50ffebe5149": Node name xxx is reserved by node c0abfb06-0a15-28de-72cf-1c17452d1a90 with name xxx
```bash
consul leave
```
rejecting vote request since we have a leader
Workaround:
consul leave in consul server

### Backup and restore
```bash
consul snapshot save backup.snap
consul snapshot restore backup.snap
```

### Remove service
```bash
curl http://localhost:8500/v1/catalog/service/SERVICE_NAME
cat > /tmp/service.json << EOF
{
  "Datacenter": "",
  "Node": "NODE_NAME",
  "ServiceID": "SERVICE_NAME"
}
EOF
curl -XPUT -d @/tmp/service.json http://localhost:8500/v1/catalog/deregister
```
### Reference
* [consul-helm](https://github.com/hashicorp/consul-helm)
* [service-registration-external-services](https://learn.hashicorp.com/tutorials/consul/service-registration-external-services)
* [UDP port 8301 does not work with client.exposeGossipPort set to true](https://github.com/hashicorp/consul-helm/issues/389)
* [network may be misconfigured](https://github.com/hashicorp/consul/issues/5195)
* [backup and restore](https://learn.hashicorp.com/tutorials/consul/backup-and-restore)
