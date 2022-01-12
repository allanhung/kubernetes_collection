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

#### halyard in kubernetes
```bash
cat << EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/managed-by: Helm
  name: halyard
  namespace: spinnaker
spec:
  replicas: 1
  selector:
    matchLabels:
      app: halyard
  template:
    metadata:
      labels:
        app: halyard
    spec:
      containers:
      - command:
        - sh
        - -c
        - cp -r /home/spinnaker/hal /home/spinnaker/.hal/ && /opt/halyard/bin/halyard
        image: us-docker.pkg.dev/spinnaker-community/docker/halyard:stable
        imagePullPolicy: IfNotPresent
        name: halyard
        volumeMounts:
        - mountPath: /home/spinnaker/hal
          name: config
        - mountPath: /home/spinnaker/hal/default/profiles
          name: profiles
        - mountPath: /home/spinnaker/hal/default/service-settings
          name: service-settings
      volumes:
      - configMap:
          items:
          - key: config
            path: config
          - key: kubeconfig.yml
            path: kubeconfig.yml
          name: hal
        name: config
      - configMap:
          items:
          - key: echo-local.yml
            path: echo-local.yml
          - key: gate-local.yml
            path: gate-local.yml
          name: hal
        name: profiles
      - configMap:
          items:
          - key: deck.yml
            path: deck.yml
          - key: gate.yml
            path: gate.yml
          - key: redis.yml
            path: redis.yml
          name: hal
        name: service-settings
EOF
```

#### create kubernetes account
```bash
hal config provider kubernetes account add my-k8s-account --kubeconfig-file my-kube-config --context my-context
hal config provider kubernetes account edit my-k8s-account --add-custom-resource SparkApplication
# Set the deploy endpoint
hal config deploy edit --type distributed --account-name my-k8s-account
hal deploy apply
```

### delete kubernetes account
```bash
hal config provider kubernetes account delete my-k8s-account
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

### Config Spinnaker github artifact
```bash
hal config artifact github account list
hal config artifact github account edit <account_name> --token <token>
hal deploy apply
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
```

### Restore
```bash
hal backup restore --backup-path <backup-name>.tar
```

### write hal config to configmap
```
mkdir hal && cd hal
tar -zxf ../halyard-2021-08-06_07-13-32-717Z.tar
gsed -i -e "s/kubeconfigFile:.*/kubeconfigFile: myconfig.yml/g" config
kubectl delete cm hal
kubectl create cm hal --from-file=myconfig.yml --from-file=config --from-file=./default/service-settings/deck.yml --from-file=./default/profiles/echo-local.yml --from-file=./default/profiles/gate-local.yml --from-file=./default/service-settings/gate.yml --from-file=./default/service-settings/redis.yml
```

### Upgrade spinnaker
```bash
kubectl set image deployment halyard halyard=us-docker.pkg.dev/spinnaker-community/docker/halyard:stable --record
kubectl exec -ti halyard-c79bb874-bc68g bash
# confirm deploy target
export KUBECONFIG=~/.hal/kubeconfig.yml
kubectl config get-contexts
hal version list
export OLDVERSION=1.22.1
export VERSION=1.26.6
hal config version edit --version $VERSION
hal deploy apply
```

### check clouddriver log
```bash
kubectl logs spin-clouddriver-77f997798b-dpp4d |grep -i unsupport |uniq
No replicaSet is supported at api version extensions/v1beta1
No deployment is supported at api version extensions/v1beta1
```

### set component version
```bash
kubectl set image deploy/spin-clouddriver clouddriver=us-docker.pkg.dev/spinnaker-community/docker/clouddriver:7.3.5-20210624040021 --record
```


### Downgrade spinnaker
```bash
hal config version edit --version $VERSION
hal deploy apply
```

### Enable teams
```bash
cat >> /home/spinnaker/.hal/default/profiles/echo-local.yml << EOF

microsoftteams:
  enabled: true
EOF
hal deploy apply
```

### Reference
* [Install and Configure Spinnaker](https://spinnaker.io/setup/install/)
* [disable configmap versioning](https://spinnaker.io/reference/providers/kubernetes-v2/#strategy)
* [zombie-executions](https://spinnaker.io/guides/runbooks/orca-zombie-executions/)
* [Error fetching new jobs from Travis](https://github.com/spinnaker/spinnaker/issues/5459#issuecomment-592114357)
* [deployment ignores apiVersion](https://github.com/kubernetes/kubernetes/issues/62283)
* [kubernetes - Breaking Update API versions](https://github.com/spinnaker/clouddriver/commit/01f415f318a15970729b4415167e64eafeca9593)
* [clouddriver kubernetes deployment support version](https://github.com/spinnaker/clouddriver/blob/master/clouddriver-kubernetes/src/main/java/com/netflix/spinnaker/clouddriver/kubernetes/op/handler/KubernetesDeploymentHandler.java#L20)
* [clouddriver v7.3.5 kubernetes deployment support version](https://github.com/spinnaker/clouddriver/blob/version-7.3.5/clouddriver-kubernetes/src/main/java/com/netflix/spinnaker/clouddriver/kubernetes/op/handler/KubernetesDeploymentHandler.java#L20-L23)
* [Zombie Executions](https://spinnaker.io/docs/guides/runbooks/orca-zombie-executions/)
