### Host Helm repositories within Nexus.
* Create a helm repository on Nexus using the Helm (hosted) recipe.
* Pushing Helm charts to Nexus
```bash
helm package <chart_dir>
curl --http1.1 -u <NEXUS_USERNAME>:<NEXUS_PASSWORD> -F file=@my-chart-version.tgz https://nexus.mydomain.com/service/rest/v1/components?repository=myhelmrepo
```
* add helm repo
```bash
helm repo add nexus --username <NEXUS_USERNAME> --password <NEXUS_PASSWORD> https://nexus.mydomain.com/repository/myhelmrepo/
```
* Test helm repo
```bash
helm repo update
helm search repo my-chart
```
* Download charts with curl
```bash
curl -O -u <NEXUS_USERNAME>:<NEXUS_PASSWORD> https://nexus.mydomain.com/repository/myhelmrepo/my-chart-version.tgz
```

### Reference
* [Helm With Sonatype Nexus](https://betterprogramming.pub/how-to-helm-with-sonatype-nexus-c49c98324a19)
* [chart-releaser](https://github.com/helm/chart-releaser)
* [chart-releaser-action](https://github.com/helm/chart-releaser-action)
* [example](https://github.com/allanhung/vault-exporter/blob/master/.github/workflows/release.yaml)
