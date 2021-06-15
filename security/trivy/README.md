### Travis CI
```yaml
before_install:
  - export VERSION=$(curl --silent "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
  - wget https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/trivy_${VERSION}_Linux-64bit.tar.gz
  - tar zxvf trivy_${VERSION}_Linux-64bit.tar.gz

script:
  - ./trivy --exit-code 0 --severity HIGH --no-progress <docker image>
  - ./trivy --exit-code 1 --severity CRITICAL --no-progress <docker image>

cache:
  directories:
    - $HOME/.cache/trivy
```

### Reference
* [trivy](https://github.com/aquasecurity/Trivy)
* [trivy with travis ci](https://aquasecurity.github.io/trivy/latest/integrations/travis-ci/)
