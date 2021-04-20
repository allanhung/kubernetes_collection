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
```

### Reference
* [Install and Configure Spinnaker](https://spinnaker.io/setup/install/)
* [disable configmap versioning](https://spinnaker.io/reference/providers/kubernetes-v2/#strategy)
