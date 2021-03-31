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

### Reference
* [argo helm chart](https://github.com/argoproj/argo-helm)
* [argo sso](https://github.com/argoproj/argo-workflows/blob/master/docs/argo-server-sso.md)
* [argo ci/cd](https://iter01.com/583436.html)
* [couler]((https://github.com/couler-proj/couler)
* [Automation of Everything](https://www.youtube.com/watch?v=XNXJtxkUKeY)
