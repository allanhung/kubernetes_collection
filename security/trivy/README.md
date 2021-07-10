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

### Local test
```bash
curl -LO https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_macOS-64bit.tar.gz
tar -zxf trivy_0.18.3_macOS-64bit.tar.gz && rm -f trivy_0.18.3_macOS-64bit.tar.gz
mv trivy /usr/local/bin
trivy image python:3.4-alpine
```
```bash
cat > Dockerfile.trivy.
docker run -d --rm --name=python centos tail -f /dev/null
docker exec -ti python bash
curl -LO https://github.com/aquasecurity/trivy/releases/download/v0.18.3/trivy_0.18.3_Linux-64bit.tar.gz
tar -zxf trivy_0.18.3_Linux-64bit.tar.gz && rm -f trivy_0.18.3_Linux-64bit.tar.gz
mv trivy /usr/local/bin
```
dnf install -y python3-pip
pipi3 install pipenv
pipenv --three
pipenv install urllib3==1.22

docker cp python:/Pipfile.lock .
trivy fs Pipfile.lock

### Safety DB
curl -LO https://github.com/pyupio/safety-db/raw/master/data/insecure_full.json
pip install urllib3==1.22
trivy fs /usr/local/lib/python3.4/site-packages
cat > requirements.txt << EOF
urllib3==1.22
EOF

print("test urllib3")
EOF

### Reference
* [trivy](https://github.com/aquasecurity/Trivy)
* [trivy with travis ci](https://aquasecurity.github.io/trivy/latest/integrations/travis-ci/)
* [trivy commercial usage](https://github.com/aquasecurity/trivy/issues/491)
* [depend on safety-db](https://github.com/aquasecurity/trivy/issues/344)
* [Add github security advisory](https://github.com/aquasecurity/trivy-db/pull/28)
* [More generic support for Python](https://github.com/aquasecurity/trivy/issues/492)
* [Better detection of Python and Node packages](https://github.com/aquasecurity/trivy/issues/1039)
* [Supported OS](https://aquasecurity.github.io/trivy/latest/vuln-detection/os)
* [Application Dependencies](https://aquasecurity.github.io/trivy/latest/vuln-detection/library)
