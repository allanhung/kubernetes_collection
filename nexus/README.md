## Installation
```bash
helm repo add sonatype https://sonatype.github.io/helm3-charts/
helm repo update

export VERSION=3.37.1

helm pull sonatype/nexus-repository-manager --untar --version ${VERSION}
patch -p1 < ingress.${VERSION}.patch
patch -p1 < alicloud-pv.patch

helm upgrade --install nxrm \
  --namespace nexus \
  --create-namespace \
  -f values.yaml \
  -f values.alicloud.yaml \
  ./nexus-repository-manager
```

## Install SSL Certificates for Client-Certificate based authentication
* get ssl certificates from issuer (client.cert, client.key)
* convert certificates to type pkcs12
```bash
openssl pkcs12 -export -out client.p12 -in client.cert -inkey client.key -password pass:1234qwer
```
* create java store with keytool
```bash
keytool -importkeystore -srckeystore client.p12 -srcstoretype pkcs12 -srcstorepass 1234qwer -destkeystore nexus.jks -deststoretype JKS -deststorepass 1234qwer
keytool -importkeystore -srckeystore nexus.jks -srcstorepass 1234qwer -destkeystore nexus.jks -deststoretype pkcs12 -deststorepass 1234qwer
```
* add the JVM parameters configuring the truststore file location and password
```bash
-Djavax.net.ssl.trustStore=<absolute_path_to_custom_truststore_file>
-Djavax.net.ssl.trustStorePassword=<truststore_password>
```

## Restore
* Create disk from snapshot
* Sprcify disk-id to persistence.pdName in vaules.alicloud.yaml
* deploy with helm chart

## Reference
* [Nexus Public Repo](https://github.com/sonatype/nexus-public)
* [Nexus Dockerfile](https://github.com/sonatype/docker-nexus3)
* [Nexus Helm Chart](https://github.com/sonatype/helm3-charts)
* [Trusting SSL Certificates Using Keytool](https://help.sonatype.com/repomanager3/nexus-repository-administration/configuring-ssl#ConfiguringSSL-OutboundSSL-TrustingSSLCertificatesUsingKeytool)
* [S3 Blobstore: Support for buckets that don't support certain features](https://github.com/sonatype/nexus-public/pull/94)
* [Aliyun Object Storage Service vs AWS S3](https://medium.com/@arsenyspb/migrate-api-from-aws-s3-to-aliyun-oss-640dd1e74201)
* [Add Alibaba Object Storage support to Nexus Repository blob store](https://issues.sonatype.org/browse/NEXUS-24448)
