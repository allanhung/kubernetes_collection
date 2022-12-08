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
helm pull argo/argo-workflows --untar
patch -p1 < artifact.patch.v3

kubectl apply -f argo-workflows/crds/

helm upgrade --install argo-workflows \
  -n argo \
  --create-namespace \
  -f ./values.yaml \
  -f ./values.example.yaml \
  --set artifactRepository.oss.bucket=argo-bucket \
  --set controller.persistence.mysql.host=mysqlhost \
  ./argo-workflows

rm -rf ./argo-workflows
```

#### Manage CRD by helm chart
```
export ARGOWF_NAMESPACE="argo"
export ARGOWF_RELEASENAME="argo-workflow"

for crd in "clusterworkflowtemplates.argoproj.io" "cronworkflows.argoproj.io" "workfloweventbindings.argoproj.io" "workflows.argoproj.io" "workflowtaskresults.argoproj.io" "workflowtasksets.argoproj.io" "workflowtemplates.argoproj.io"; do
  kubectl label --overwrite crd $crd app.kubernetes.io/managed-by=Helm
  kubectl annotate --overwrite crd $crd meta.helm.sh/release-namespace="$ARGOWF_NAMESPACE"
  kubectl annotate --overwrite crd $crd meta.helm.sh/release-name="$ARGOWF_RELEASENAME"
done
```

### Dashboard
* [14136](https://grafana.com/grafana/dashboards/14136)
* [13927](https://grafana.com/grafana/dashboards/13927)

### Reference
* [argo helm chart](https://github.com/argoproj/argo-helm)
* [argo sso](https://github.com/argoproj/argo-workflows/blob/master/docs/argo-server-sso.md)
* [ci/cd by argo workflow](https://iter01.com/583436.html)
* [couler]((https://github.com/couler-proj/couler)
* [Automation of Everything](https://www.youtube.com/watch?v=XNXJtxkUKeY)
* [token not valid for running mode](https://github.com/argoproj/argo-workflows/issues/4991)
* [auth mode](https://github.com/argoproj/argo-workflows/blob/master/docs/argo-server-auth-mode.md)
* [Remove non-Emissary executors](https://github.com/argoproj/argo-workflows/issues/7829)
