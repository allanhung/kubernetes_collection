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
export VERSION=$(curl --silent "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -LO https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/trivy_${VERSION}_macOS-64bit.tar.gz
mkdir -p tmp && tar -zxf trivy_${VERSION}_macOS-64bit.tar.gz -C tmp/ && rm -f trivy_${VERSION}_macOS-64bit.tar.gz
mv tmp/trivy /usr/local/bin && rm -rf tmp
trivy image python:3.4-alpine
```
trivy ghcr.io/christophetd/log4shell-vulnerable-app
```bash
cat > Dockerfile.trivy.
docker run -d --rm --name=python centos tail -f /dev/null
docker exec -ti python bash
export VERSION=$(curl --silent "https://api.github.com/repos/aquasecurity/trivy/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -LO https://github.com/aquasecurity/trivy/releases/download/v${VERSION}/trivy_${VERSION}_Linux-64bit.tar.gz
tar -zxf trivy_${VERSION}_Linux-64bit.tar.gz && rm -f trivy_${VERSION}_Linux-64bit.tar.gz
mv trivy /usr/local/bin
```
dnf install -y python3-pip
pipi3 install pipenv
pipenv --three
pipenv install urllib3==1.22

docker cp python:/Pipfile.lock .
trivy fs Pipfile.lock

### Scan all image in kubernetes
kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" |\tr -s '[[:space:]]' '\n' |\sort |\uniq > podlist
while read line; do echo $line; done < /tmp/podlist
cat > podlist << EOF
python:3.4-alpine
ghcr.io/christophetd/log4shell-vulnerable-app
EOF
xargs -I {} sh -c "(trivy {} |grep CVE-2021-44228 && echo {}) > podscan.result" < podlist


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
* [Added capability to filter data sources](https://github.com/aquasecurity/trivy/pull/1467)
* [add_filter_data_sources](https://github.com/liorkesten/trivy/tree/liorkesten/add_filter_data_sources)
