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

### Reference
* [lInstall and Configure Spinnake](https://spinnaker.io/setup/install/)
