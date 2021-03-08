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

### Reference
* [Install and Configure Spinnaker](https://spinnaker.io/setup/install/)
