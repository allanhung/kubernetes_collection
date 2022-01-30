## Installation
```bash
helm upgrade --install halyard \
  --namespace spinnaker \
  --create-namespace \
  -f values.yaml \
  ./
```

## Restore
### backup (Source)
```
export PODNAME=$(kubectl get pods -n spinnaker |grep halyard | awk {'print $1'})
kubectl -n spinnaker exec -ti ${PODNAME} bash
$ hal backup create
+ Create backup
  Success
+ Successfully created a backup at location:
/home/spinnaker/halyard-2022-01-27_08-05-08-349Z.tar
$ exit
export BAKFILE=halyard-2022-01-27_08-05-08-349Z.tar
mkdir hal && cd hal
kubectl -n spinnaker cp ${PODNAME}:/home/spinnaker/${BAKFILE} ${BAKFILE}
kubectl -n spinnaker cp ${PODNAME}:/home/spinnaker/.hal/saml/metadata.xml metadata.xml
kubectl -n spinnaker cp ${PODNAME}:/home/spinnaker/.hal/saml/spinnaker.jks spinnaker.jks
tar -zxf ${BAKFILE}
gsed -i -e "s/kubeconfigFile:.*/kubeconfigFile: kubeconfig.yml/g" config
gsed -i -e "s#metadataLocal:.*#metadataLocal: saml/metadata.xml#g" config
gsed -i -e "s#keyStore:.*#keyStore: saml/spinnaker.jks#g" config
```
### create configmap from backup (Target)
```bash
kubectl create cm hal -n spinnaker --from-file=kubeconfig.yml --from-file=config --from-file=./default/service-settings/deck.yml --from-file=./default/profiles/echo-local.yml --from-file=./default/profiles/gate-local.yml --from-file=./default/service-settings/gate.yml --from-file=./default/service-settings/redis.yml --from-file=./metadata.xml --from-file=./spinnaker.jks
```

### setup kubernetes deploy target (Target)
#### Get deploy account token in target kubernetes (Target)
```bash
kubectl get secret -n kube-system $(kubectl get sa spinnaker -n kube-system -o=jsonpath='{.secrets[0].name}') -o=jsonpath='{.data.token}' | base64 --decode
```

#### setup spinnaker acoount for kubernetes (Target)
```bash
$ export TOKEN=xxx
$ export CLUSTER_NAME=my-cluster
$ export CLUSTER_API_SERVER=https://47.254.33.139:6443
$ export KUBECONFIG=/home/spinnaker/.hal/kubeconfig.yml
$ hal config provider kubernetes account list
$ kubectl config set-cluster ${CLUSTER_NAME} --server=${CLUSTER_API_SERVER} --insecure-skip-tls-verify=true
$ kubectl config set-credentials ${CLUSTER_NAME} --token=${TOKEN}
$ kubectl config set-context ${CLUSTER_NAME} --cluster=${CLUSTER_NAME} --user=${CLUSTER_NAME}
$ kubectl config use-context ${CLUSTER_NAME}
$ hal config provider kubernetes account add ${CLUSTER_NAME} --provider-version v2 --context $(kubectl config current-context) --kubeconfig-file ${KUBECONFIG}
$ hal config provider kubernetes account edit ${CLUSTER_NAME} --add-custom-resource SparkApplication
$ hal config deploy edit --type distributed --account-name ${CLUSTER_NAME}
$ hal config provider kubernetes account list
```

### remove spinnaker acoount for kubernetes (Optional) (Target)
```bash
$ hal config provider kubernetes account list
$ hal config provider kubernetes account delete <cluster_name>
$ hal config provider kubernetes account list
```

### setup spinnaker deploy target (Target)
```bash
$ hal config deploy edit --account-name <cluster_name>
```

### setup spinnaker endpoint (Target)
```bash
$ hal config security api edit --override-base-url https://spinnaker-api.mydomain.com
$ hal config security ui edit --override-base-url https://spinnaker.mydomain.com
$ hal config security authn oauth2 edit --pre-established-redirect-uri https://spinnaker-api.mydomain.com/login
$ hal config security authn saml edit --service-address-url https://spinnaker-api.mydomain.com
```

### disable saml (Optional) (Target)
```bash
$ hal config security authn saml disable
```

### disable oauth2 (Optional) (Target)
```bash
$ hal config security authn oauth2 disable
```

### deploy spinnaker to target
```bash
$ hal deploy apply
```

## Config Spinnaker github artifact
```bash
$ hal config features edit –artifacts true
$ hal config artifact github enable
$ hal config artifact github account add $<account_name> --token <token>
$ hal config artifact github account list
$ hal config artifact github account edit <account_name> --token <token>
$ hal deploy apply
```

## Backup hal config
```bash
$ hal backup create
```

## Restore from hal backup
```bash
$ hal backup restore --backup-path <backup-file>
```


## Migrate spinnaker to specify version
* upgrade halyard
```bash
kubectl -n spinnaker set image deployment halyard halyard=us-docker.pkg.dev/spinnaker-community/docker/halyard:stable --record
```
* upgrade spinnaker by hal
```bash
kubectl -n spinnaker exec -ti deploy/halyard bash
hal version list
export VERSION=1.26.6
hal config version edit --version $VERSION
hal deploy apply
```

## Enable teams
```bash
cat >> /home/spinnaker/.hal/default/profiles/echo-local.yml << EOF

microsoftteams:
  enabled: true
EOF
hal deploy apply
```

## Spinnaker Oauth Setup
* OIDC
```bash
hal config security authn oauth2 edit \
    --client-id $CLIENT_ID \
    --client-secret $CLIENT_SECRET \
    --provider $PROVIDER \
    --user-info-requirements <key=value>
```
* SAML
```bash
hal config security authn saml edit \
    --keystore ${KEYSTORE_FILE} \ # keytool -genkey -v -keystore ${KEYSTORE_FILE} -alias saml -keyalg RSA -keysize 2048 -validity 10000
    --keystore-alias saml \
    --keystore-password ${KEYSTORE_PASSWORD} \
    --metadata ${METADATA_FILE} \ # metadata.xml from provider
    --issuer-id ${ISSUER_ID} \
    --service-address-url ${SPINNAKER_API_URL}
```

## TroubleShooting
* Log
```bash
kubectl logs -l app.kubernetes.io/name=deck -c deck --tail=5 -f
kubectl logs -l app.kubernetes.io/name=echo -c echo --tail=5 -f
kubectl logs -l app.kubernetes.io/name=orca -c orca --tail=5 -f
kubectl logs -l app.kubernetes.io/name=clouddriver -c clouddriver --tail=5 -f
kubectl logs -l app.kubernetes.io/name=rosco -c rosco --tail=5 -f
```
* delete execution
```bash
curl -X POST http://spin-orca.spinnaker.svc:8083/admin/queue/zombies/{executionId}:kill
```
* cancel execution
```bash
curl -X PUT http://spin-orca.spinnaker.svc:8083/pipelines/{executionId}/cancel
```
* Hang on Wait For Manifest To Stabilize
Workaroud: delete the pipeline and recreate.
* kuberntes api version not support by spinnaker clouddriver
check:
```bash
kubectl logs -l app.kubernetes.io/name=clouddriver -c clouddriver |grep -i unsupport |uniq
No replicaSet is supported at api version extensions/v1beta1
No deployment is supported at api version extensions/v1beta1
```
Workaroud: Downgrade clouddriver version
```bash
kubectl set image deploy/spin-clouddriver clouddriver=us-docker.pkg.dev/spinnaker-community/docker/clouddriver:7.3.5-20210624040021 --record
```

## Reference
* [Install and Configure Spinnaker](https://spinnaker.io/setup/install/)
* [disable configmap versioning](https://spinnaker.io/reference/providers/kubernetes-v2/#strategy)
* [zombie-executions](https://spinnaker.io/guides/runbooks/orca-zombie-executions/)
* [Error fetching new jobs from Travis](https://github.com/spinnaker/spinnaker/issues/5459#issuecomment-592114357)
* [deployment ignores apiVersion](https://github.com/kubernetes/kubernetes/issues/62283)
* [kubernetes - Breaking Update API versions](https://github.com/spinnaker/clouddriver/commit/01f415f318a15970729b4415167e64eafeca9593)
* [clouddriver kubernetes deployment support version](https://github.com/spinnaker/clouddriver/blob/master/clouddriver-kubernetes/src/main/java/com/netflix/spinnaker/clouddriver/kubernetes/op/handler/KubernetesDeploymentHandler.java#L20)
* [clouddriver v7.3.5 kubernetes deployment support version](https://github.com/spinnaker/clouddriver/blob/version-7.3.5/clouddriver-kubernetes/src/main/java/com/netflix/spinnaker/clouddriver/kubernetes/op/handler/KubernetesDeploymentHandler.java#L20-L23)
* [Zombie Executions](https://spinnaker.io/docs/guides/runbooks/orca-zombie-executions/)
