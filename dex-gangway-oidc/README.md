### Prerequiement
```bash
brew install gomplate
```

### Create your own values.yaml
```yaml
cluster_name: my-cluster

dex:
  issuer: https://my-issuer.my-domain.com
  clientID: my-client-id
  clientSecret: my-client-password # openssl rand -hex 16
  url: dex.my-domain.com

gangway:
  url: gangway.my-domain.com
  secret: my-gangway-secret
  sessionkey: rdL7y/zFrpT4Bhy8+mduepCsk4DRZnwWH7UhK0EXdgE= # openssl rand -base64 32

grafana:
  url: grafana.my-domain.com
  secret: my-grafana-secret

oidc:
  url: kube-oidc-proxy.my-domain.com
```
### Generate Yaml

```bash
cd kustomize/base
gomplate -d values=./values.yaml -f dex-config.yaml.tmpl -o dex-config.yaml
gomplate -d values=./values.yaml -f dex-ingress.yaml.tmpl -o dex-ingress.yaml
gomplate -d values=./values.yaml -f gangway-config.yaml.tmpl -o gangway-config.yaml
gomplate -d values=./values.yaml -f gangway-deployment.yaml.tmpl -o gangway-deployment.yaml
gomplate -d values=./values.yaml -f gangway-ingress.yaml.tmpl -o gangway-ingress.yaml
gomplate -d values=./values.yaml -f oidc-deployment.yaml.tmpl -o oidc-deployment.yaml
gomplate -d values=./values.yaml -f oidc-ingress.yaml.tmpl -o oidc-ingress.yaml
gomplate -d values=./values.yaml -f kustomization.yaml.tmpl -o kustomization.yaml
kustomize build .
```

### deploy into kubernetes
```
kustomize build . | kubectl apply -f -
```

### grant permission to oidc user
```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: oidc-admin-role
rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: oidc-admin-role-binding
subjects:
  - kind: User
    name: oidc:my-name@my-domain.com
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: oidc-admin-role
  apiGroup: rbac.authorization.k8s.io
```

### Test token
```
export TOKEN=my-token
export API_SERVER=10.0.0.1:6443
curl -H "Authorization: Bearer ${TOKEN} -k https://${API_SERVER}/api/v1/namespaces/default/pods
```

## Reference
* [gomplate](https://github.com/hairyhenderson/gomplate)
* [cert-manager](https://github.com/jetstack/cert-manager)
* [dex](https://github.com/dexidp/dex)
* [gangway](https://github.com/heptiolabs/gangway)
* [kube-oidc-proxy](https://github.com/jetstack/kube-oidc-proxy)
* [dex okta groups](https://harivemula.com/2020/07/02/enable-oidc-groups-based-access-to-tanzu-kubernetes-grid/)
* [dex storage](https://blog.csdn.net/u014618114/article/details/104442808)
* [refresh token](https://github.com/dexidp/dex/issues/973)
* [Support multiple refresh tokens per user](https://github.com/dexidp/dex/pull/1829)
* [Allow multiple refresh tokens for a client-user pair](https://github.com/dexidp/dex/issues/981)
