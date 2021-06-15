### Installation
```bash
helm repo add wiremind https://wiremind.github.io/wiremind-helm-charts
helm pull wiremind/clair --untar && patch -p1 < clair.helm.patch
helm dependency update ./clair
helm upgrade --install clair \
  --namespace infra \
  -f ./values.yaml \
  ./clair
```

### Travis CI
```yaml
before_install:
  - export CLAIR_VERSION=$(curl --silent "https://api.github.com/repos/quay/clair/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
  - curl -L -o clairctl https://github.com/quay/clair/releases/download/v${CLAIR_VERSION}/clairctl-linux-amd64
  - chmod 755 clairctl

script:
  - docker push <docker image>
  - ./clairctl-darwin-amd64 manifest <docker image> | jq -r '.hash'
  - ./clairctl report --host https://clair.my-domain.com <docker image> | tee clair_report
```

### Get report
```bash
clairctl manifest <CONTAINER>
curl 'https://clair.my-domain.com/matcher/api/v1/vulnerability_report/<CONTAINER_MANIFEST_ID>'
```

### Reference
* [clair](https://github.com/quay/clair)
* [claircore](https://github.com/quay/claircore)
* [clair doc](https://quay.github.io/clair)
* [Scan Container Images with Clair V4 in CI/CD Pipeline](https://www.youtube.com/watch?v=fjlEGF4qyQ0)
* [Scan Container Images with Clair V4 in CI/CD Pipeline - Repo](https://gitlab.com/FJCorp/languagetool)
* [charts](https://github.com/wiremind/wiremind-helm-charts/tree/main/charts/clair)
* [default Matchers](https://github.com/quay/clair/blob/main/config/matchers.go)
* [default Updaters](https://github.com/quay/clair/blob/main/config/updaters.go)
