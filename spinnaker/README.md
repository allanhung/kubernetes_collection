### Installation
#### halyard
```bash
mkdir -p ~/.hal
docker run -d --name halyard --rm \
    -v ~/.hal:/home/spinnaker/.hal \
    -v ~/.kube:/home/spinnaker/.kube \
    -p 8084:8084 -p 9000:9000 \
    us-docker.pkg.dev/spinnaker-community/docker/halyard:stable
```

#### create kubernetes account
```bash
hal config provider kubernetes account add my-k8s-account --kubeconfig-file my-kube-config --context my-context
hal config provider kubernetes account edit my-k8s-account --add-custom-resource SparkApplication
# Set the deploy endpoint
hal config deploy edit --type distributed --account-name my-k8s-account
hal deploy apply
```

### TroubleShooting
```bash
kubectl logs -l app.kubernetes.io/name=deck -c deck --tail=5 -f
kubectl logs -l app.kubernetes.io/name=echo -c echo --tail=5 -f
kubectl logs -l app.kubernetes.io/name=orca -c orca --tail=5 -f
kubectl logs -l app.kubernetes.io/name=clouddriver -c clouddriver --tail=5 -f
kubectl logs -l app.kubernetes.io/name=rosco -c rosco --tail=5 -f
# delete execution
curl -X POST http://spin-orca.spinnaker.svc:8083/admin/queue/zombies/{executionId}:kill
# cancel execution
curl -X PUT http://spin-orca.spinnaker.svc:8083/pipelines/{executionId}/cancel
```
Hang on Wait For Manifest To Stabilize
Workaroud:
```
delete the pipeline and recreate.
```

### Add Spinnaker kubernetes account
```bash
kubectl apply -f rbac.yaml
TOKEN=$(kubectl get secret -n kube-system $(kubectl get sa spinnaker -n kube-system -o=jsonpath='{.secrets[0].name}') -o=jsonpath='{.data.token}' | base64 --decode)
CLUSTER=my-example-cluster
CLUSTER_API_SERVER=https://127.0.0.1:6443

hal config provider kubernetes account list
export KUBECONFIG=/home/spinnaker/.hal/myconfig.yml
kubectl config set-cluster ${CLUSTER} --server=${CLUSTER_API_SERVER} --insecure-skip-tls-verify=true
kubectl config set-credentials ${CLUSTER} --token=${TOKEN}
kubectl config set-context ${CLUSTER} --cluster=${CLUSTER} --user=${CLUSTER}
kubectl config use-context ${CLUSTER}
hal config provider kubernetes account add ${CLUSTER} --provider-version v2 --context $(kubectl config current-context) --kubeconfig-file myconfig.yml
sed -i -e "s/kubeconfigFile:.*/kubeconfigFile: myconfig.yml/g" ~/.hal/config
hal deploy apply
```

### Backup hal config
```bash
hal backup create
kubectl -n spinnaker cp halyard-c79bb874-bc68g:/home/spinnaker/halyard-2021-08-06_07-13-32-717Z.tar halyard-2021-08-06_07-13-32-717Z.tar
mkdir hal && cd hal
tar -zxf ../halyard-2021-08-06_07-13-32-717Z.tar
gsed -i -e "s/kubeconfigFile:.*/kubeconfigFile: myconfig.yml/g" config
kubectl delete cm hal
kubectl create cm hal --from-file=myconfig.yml --from-file=config --from-file=./default/service-settings/deck.yml --from-file=./default/profiles/echo-local.yml --from-file=./default/profiles/gate-local.yml --from-file=./default/service-settings/gate.yml --from-file=./default/service-settings/redis.yml
```

### Reference
* [Install and Configure Spinnaker](https://spinnaker.io/setup/install/)
* [disable configmap versioning](https://spinnaker.io/reference/providers/kubernetes-v2/#strategy)
* [zombie-executions](https://spinnaker.io/guides/runbooks/orca-zombie-executions/)
* [Error fetching new jobs from Travis](https://github.com/spinnaker/spinnaker/issues/5459#issuecomment-592114357)
