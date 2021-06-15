# Prepare
## setup parameter
```bash
export ISTIO_VER=1.9.0
export ISTIO_TM_VER=1.7.6
export ISTIO_SRC_DIR=~/Downloads/git/kubernetes_collection
export OS=osx
mkdir -p ${ISTIO_SRC_DIR}/istio/charts
mkdir -p ${ISTIO_SRC_DIR}/istio/download
mkdir -p ${ISTIO_SRC_DIR}/istio/${ISTIO_TM_VER}
mkdir -p ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin
mkdir -p ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/config
```
## download istio-telemetry from istio 1.7.6
```bash
curl -L -o ${ISTIO_SRC_DIR}/istio/download/istio-${ISTIO_TM_VER}-linux-arm64.tar.gz https://github.com/istio/istio/releases/download/${ISTIO_TM_VER}/istio-${ISTIO_TM_VER}-linux-arm64.tar.gz
tar -zxvf ${ISTIO_SRC_DIR}/istio/download/istio-${ISTIO_TM_VER}-linux-arm64.tar.gz -C ${ISTIO_SRC_DIR}/istio/${ISTIO_TM_VER}
mv ${ISTIO_SRC_DIR}/istio/${ISTIO_TM_VER}/istio-${ISTIO_TM_VER} ${ISTIO_SRC_DIR}/istio/${ISTIO_TM_VER}/release
rsync -avP ${ISTIO_SRC_DIR}/istio/${ISTIO_TM_VER}/release/manifests/charts/istio-telemetry/prometheusOperator ${ISTIO_SRC_DIR}/istio/charts/
cd ${ISTIO_SRC_DIR}/istio && patch -p1 < ${ISTIO_SRC_DIR}/istio/patch/prometheusOperator.patch
```

## insatll istioctl binary
```bash
curl -L -o ${ISTIO_SRC_DIR}/istio/download/istioctl-${ISTIO_VER}-${OS}.tar.gz https://github.com/istio/istio/releases/download/${ISTIO_VER}/istioctl-${ISTIO_VER}-${OS}.tar.gz
tar -zxvf ${ISTIO_SRC_DIR}/istio/download/istioctl-${ISTIO_VER}-${OS}.tar.gz -C ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/
```
## download istio release
```bash
curl -L -o ${ISTIO_SRC_DIR}/istio/download/istio-${ISTIO_VER}-linux-arm64.tar.gz https://github.com/istio/istio/releases/download/${ISTIO_VER}/istio-${ISTIO_VER}-linux-arm64.tar.gz
tar -zxvf ${ISTIO_SRC_DIR}/istio/download/istio-${ISTIO_VER}-linux-arm64.tar.gz -C ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}
mv ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/istio-${ISTIO_VER} ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release
cd ${ISTIO_SRC_DIR}/istio/${ISTIO_VER} && patch -p1 < ${ISTIO_SRC_DIR}/istio/patch/istio-ingress.patch
```
# Installation
## Generate ca
```bash
mkdir -p ${ISTIO_SRC_DIR}/istio/certs && cd ${ISTIO_SRC_DIR}/istio/certs
make -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/tools/certs/Makefile.selfsigned.mk root-ca
make -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/tools/certs/Makefile.selfsigned.mk cluster1-us-east-1-cacerts
make -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/tools/certs/Makefile.selfsigned.mk cluster1-us-west-1-cacerts

kubectl get ns istio-system || kubectl create namespace istio-system
kubectl get secret cacerts || kubectl create secret generic cacerts -n istio-system \
      --from-file=cluster1-us-east-1/ca-cert.pem \
      --from-file=cluster1-us-east-1/ca-key.pem \
      --from-file=cluster1-us-east-1/root-cert.pem \
      --from-file=cluster1-us-east-1/cert-chain.pem
```

## Install by Helm
### base creates cluster-wide CRDs, cluster bindings, cluster resources and the istio-system namespace.
```bash
helm upgrade --install istio-base \
    --namespace istio-system \
    --create-namespace \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/base
```
### istio-control/istio-discovery installs a revision of istiod.
```bash
helm upgrade --install istiod \
    --namespace istio-system \
    -f ${ISTIO_SRC_DIR}/istio/values.inject.yaml \
    --set global.hub=my-docker-io-proxy/istio \
    --set global.meshID=vpc1-mesh \
    --set global.multiCluster.clusterName=cluster1-us-east-1 \
    --set global.network=vpc1.us-east-1 \
    --set global.proxy.logLevel=debug \
    --set global.accessLogFile=/dev/stdout \
    --set global.jwtPolicy=first-party-jwt \
    --set global.arch.s390x=0 \
    --set global.arch.ppc64le=0 \
    --set global.tracer.zipkin.address=jaeger-collector.tracing.svc:9411 \
    --set pilot.traceSampling=1 \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/istio-control/istio-discovery
```
#### if caBundle is missing, patch webhook caBundle after istio-control/istio-discovery installation
```bash
export CABUNDLE=$(kubectl -n istio-system get secret istio-ca-secret -o jsonpath='{.data.ca-cert\.pem}')
kubectl patch mutatingwebhookconfiguration istio-sidecar-injector --record --type='json' -p='
[
  {
    "op": "replace",
    "path": "/webhooks/0/clientConfig/caBundle",
    "value": "'${CABUNDLE}'"
  }
]'
```
### create cluster context for mesh
```bash
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl x create-remote-secret --context=my-context-in-kubeconfig --name=cluster1-us-west-1 | kubectl apply -f -
```

### gateways/istio-ingress install a Gateway
```bash
helm upgrade --install istio-ingress-internal \
    --namespace istio-system \
    --set global.hub=my-docker-io-proxy/istio \
    --set global.meshID=vpc1-mesh \
    --set global.multiCluster.clusterName=cluster1-us-east-1 \
    --set global.network=vpc1.us-east-1 \
    --set global.jwtPolicy=first-party-jwt \
    --set global.arch.s390x=0 \
    --set global.arch.ppc64le=0 \
    --set global.defaultPodDisruptionBudget.enabled=false \
    --set gateways.istio-ingressgateway.name=istio-ingress-internal \
    --set gateways.istio-ingressgateway.labels.app=istio-ingress-internal \
    --set gateways.istio-ingressgateway.labels.istio=ingress-internal \
    --set gateways.istio-ingressgateway.daemonsetEnabled=true \
    --set gateways.istio-ingressgateway.externalTrafficPolicy=Local \
    --set gateways.istio-ingressgateway.serviceAnnotations."service\.beta\.kubernetes\.io/alibaba-cloud-loadbalancer-address-type"=intranet \
    --set gateways.istio-ingressgateway.serviceAnnotations."service\.beta\.kubernetes\.io/alicloud-loadbalancer-force-override-listeners"=true \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/gateways/istio-ingress

helm upgrade --install istio-ingress-external \
    --set global.hub=my-docker-io-proxy/istio \
    --namespace istio-system \
    --set global.meshID=vpc1-mesh \
    --set global.multiCluster.clusterName=cluster1-us-east-1 \
    --set global.network=vpc1.us-east-1 \
    --set global.jwtPolicy=first-party-jwt \
    --set global.arch.s390x=0 \
    --set global.arch.ppc64le=0 \
    --set global.defaultPodDisruptionBudget.enabled=false \
    --set gateways.istio-ingressgateway.name=istio-ingress-external \
    --set gateways.istio-ingressgateway.labels.app=istio-ingress-external \
    --set gateways.istio-ingressgateway.labels.istio=ingress-external \
    --set gateways.istio-ingressgateway.daemonsetEnabled=true \
    --set gateways.istio-ingressgateway.externalTrafficPolicy=Local \
    --set gateways.istio-ingressgateway.serviceAnnotations."service\.beta\.kubernetes\.io/alicloud-loadbalancer-force-override-listeners"=true \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/gateways/istio-ingress
```
### Prometheus for istio (prometheusOperator or prometheus)
#### istio-telemetry/prometheusOperator install serviceMonitor
```bash
helm upgrade --install istio-servicemonitor \
    --namespace istio-system \
    --set global.telemetryNamespace=istio-system \
    --set serviceMonitor.labels.release=po \
    ${ISTIO_SRC_DIR}/istio/charts/prometheusOperator
```
### kiali
install kiali from kiali-server helm repo

### tracing
install jaeger from jaeger helm repo

## Install by Istioctl
### create profile base on default profile
```bash
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump default > ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/config/istio-default-profile.yaml
cd ${ISTIO_SRC_DIR}/istio/${ISTIO_VER} && patch -p1 < ${ISTIO_SRC_DIR}/istio/patch/profile.patch
```
### generate manifest with created profile
```bash
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl manifest generate -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/config/istio-default-profile.yaml
```
### install with created profile
```bash
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl install -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/config/istio-default-profile.yaml
```

### neverInjectSelector 
```bash
kubectl edti cm istio-sidecar-injector -n istio-system
```
# dashboard
* [7630 Istio Workload Dashboard](https://grafana.com/grafana/dashboards/7630)
* [7636 Istio Service Dashboard](https://grafana.com/grafana/dashboards/7636)
* [7639 Istio Mesh Dashboard](https://grafana.com/grafana/dashboards/7639)
* [7645 Istio Control Plane Dashboard](https://grafana.com/grafana/dashboards/7645)
* [7648 Istio Galley Dashboard](https://grafana.com/grafana/dashboards/7648)
* [11820 Istio Citadel Dashboard](https://grafana.com/grafana/dashboards/11820)
* [12153 Istio Performance Dashboard](https://grafana.com/grafana/dashboards/12153)
* [13277 Istio Wasm Extension Dashboard](https://grafana.com/grafana/dashboards/13277)
* [7642 Istio Mixer Dashboard](https://grafana.com/grafana/dashboards/7642)

# reference
* [istio helm installation](https://istio.io/latest/docs/setup/install/helm/)
* [Istio Proxy Start-up Latency](https://www.stackrox.com/post/2019/11/how-to-make-istio-work-with-your-apps/)
* [go-istio-proxy-wait](https://github.com/allisson/go-istio-proxy-wait)
* [Using Istio with CronJobs](https://github.com/istio/istio/issues/11659)
* [Sidecar: adding exceptions](https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/#more-control-adding-exceptions)
* [Service upstream support with Istio](https://github.com/kubernetes/ingress-nginx/issues/3171)
* [Nginx Controller using endpoints instead of Services](https://github.com/kubernetes/ingress-nginx/issues/257)
* [istio deployment-models](https://istio.io/latest/docs/ops/deployment/deployment-models/)
* [ibm class](https://mediacenter.ibm.com/tag/tagid/%E5%BC%80%E6%BA%90%E6%8A%80%E6%9C%AF%20*%20ibm%20%E5%BE%AE%E8%AE%B2%E5%A0%82)
* [Debugging your debugging tools](https://www.youtube.com/watch?v=XAKY24b7XjQ)
* [Debugging your debugging tools powerpoint](https://www.cncf.io/wp-content/uploads/2020/08/CNCF-Webinar-Debugging-your-debugging-tools.pptx)
* [istio handbook](https://jimmysong.io/istio-handbook/)

