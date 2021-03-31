### Prerequisites
#### Add helm repo
```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```
#### Create account and sso secret
* install argo-access

#### Upgrade / Install
```bash
helm pull argo/argo --untar
patch -p1 < artifact.patch

helm upgrade --install argo \
  -n infra \
  --create-namespace \
  -f ./values.yaml \
  -f ./values.example.yaml \
  --set artifactRepository.oss.bucket=argo-bucket \
  ./argo

rm -rf ./argo
```

### Reference
* [argo helm chart](https://github.com/argoproj/argo-helm)
* [argo sso](https://github.com/argoproj/argo-workflows/blob/master/docs/argo-server-sso.md)
* [ci/cd by argo workflow](https://iter01.com/583436.html)
* [couler]((https://github.com/couler-proj/couler)
* [Automation of Everything](https://www.youtube.com/watch?v=XNXJtxkUKeY)
* [token not valid for running mode](https://github.com/argoproj/argo-workflows/issues/4991)
* [auth mode](https://github.com/argoproj/argo-workflows/blob/master/docs/argo-server-auth-mode.md)
