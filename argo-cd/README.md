#### Prerequisites
```bash
helm repo add argo https://argoproj.github.io/argo-helm
```

#### Upgrade / Install
```bash
gsed -e "s#clientSecret:.*#clientSecret: $(vault read -format=json my-secret-path  | jq -r '.data.clientSecret')#g" ${DIR}/values.example.yaml > ${DIR}/values.tmp.yaml

helm upgrade --install argocd \
  -n argo-cd \
  --create-namespace \
  -f ./values.yaml \
  -f ./values.tmp.yaml \
  argo/argo-cd
```

#### GPG Issue
```
gpg ... --gen-key failed exit status 2
```
workaround:
```
env:
- name: ARGOCD_GPG_ENABLED
  value: "false"
```

### 10329 issue Auto refresh doesn't work, but manual hard-refresh does
```
annotations:
  argocd.argoproj.io/refresh: hard
```

### external dex setup
argocd values.yaml
```
server:
  config:
    url: https://argo-cd.exmaple.com
    oidc.config: |
      name: dex
      issuer: https://dex.example.com
      clientID: [Client ID for argocd ui]
      cliClientId: [Client ID for argocd cli]
      clientSecret: [Client Secret for argocd ui]
      requestedIDTokenClaims:
        groups:
          essential: true
      requestedScopes:
        - openid
        - profile
        - email
        - groups
```
dex values.yaml
```
config:
  issuer: https://dex.example.com
  connectors:
  - type: microsoft
    id: microsoft
    name: Microsoft
    config:
      clientID: [ClientID for idp Provider]
      clientSecret: [ClientSecret for idp Provider]
      tenant: [tenant id for idp Provider]
      redirectURI: https://dex.example.com/callback
  - id: [Client ID for argocd ui]
    redirectURIs:
    - https://argo-cd.example.com/auth/callback
    name: 'Argocd'
    secret: [Client Secret for argocd ui]
  - id: [Client ID for argocd cli]
    redirectURIs:
    - http://localhost:8085/auth/callback
    name: 'ArgocdCli'
    public: true
```
### Reference
* [argo helm chart](https://github.com/argoproj/argo-helm)
* [argo sso](https://github.com/argoproj/argo-workflows/blob/master/docs/argo-server-sso.md)
* [argo ci/cd](https://iter01.com/583436.html)
* [couler]((https://github.com/couler-proj/couler)
* [Automation of Everything](https://www.youtube.com/watch?v=XNXJtxkUKeY)
* [GPG Issue](https://github.com/argoproj/argo-cd/issues/9888)
* [repo-cache-expiration](https://github.com/argoproj/argo-cd/issues/4002)
* [Support for external dex implementation](https://github.com/argoproj/argo-cd/issues/702)
