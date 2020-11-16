export ISTIO_VER=1.7.4
export ISTIO_SRC_DIR=~/Downloads/git/kubernetes_collection
export OS=osx
mkdir -p ${ISTIO_SRC_DIR}/istio/download
mkdir -p ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin
mkdir -p ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/config
# Prepare
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
cd ${ISTIO_SRC_DIR}/istio/${ISTIO_VER} && patch -p1 < ${ISTIO_SRC_DIR}/istio/patch/prometheusOperator.patch
cd ${ISTIO_SRC_DIR}/istio/${ISTIO_VER} && patch -p1 < ${ISTIO_SRC_DIR}/istio/patch/kiali.patch
```
# Installation
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
helm upgrade --install istio-control \
    --namespace istio-system \
    -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/global.yaml \
    --set global.hub=docker.io/istio \
    --set global.tag=${ISTIO_VER} \
    --set global.jwtPolicy=first-party-jwt \
    --set global.arch.s390x=0 \
    --set global.arch.ppc64le=0 \
    --set pilot.traceSampling=1 \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/istio-control/istio-discovery
```
#### patch webhook caBundle after istio-control/istio-discovery installation
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
### gateways/istio-ingress install a Gateway
```bash
helm upgrade --install istio-ingress \
    --namespace istio-system \
    -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/global.yaml \
    --set global.hub=docker.io/istio \
    --set global.tag=${ISTIO_VER} \
    --set global.jwtPolicy=first-party-jwt \
    --set global.arch.s390x=0 \
    --set global.arch.ppc64le=0 \
    --set gateways.istio-ingressgateway.serviceAnnotations."service\.beta\.kubernetes\.io/alibaba-cloud-loadbalancer-address-type"=intranet \
    --set gateways.istio-ingressgateway.serviceAnnotations."service\.beta\.kubernetes\.io/alicloud-loadbalancer-force-override-listeners"=true \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/gateways/istio-ingress
```
### Prometheus for istio (prometheusOperator or prometheus)
#### istio-telemetry/prometheusOperator install serviceMonitor
```bash
helm upgrade --install po \
    --namespace istio-system \
    --set global.telemetryNamespace=istio-system \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/istio-telemetry/prometheusOperator
```
#### istio-telemetry/prometheus install prometheus for istio
```bash
helm upgrade --install istio-prometheus \
    --namespace istio-system \
    -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/global.yaml \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/istio-telemetry/prometheus
kubectl apply -f ${ISTIO_SRC_DIR}/istio/ingress/prometheus-ingress.yaml -n istio-system
```
### kiali
```bash
kubectl delete secret kiali -n istio-system
kubectl create secret generic kiali --from-literal=oidc-secret=dc0ea89660c026013623026ea9f9af7c -n istio-system
helm upgrade --install kiali \
    --namespace istio-system \
    -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/global.yaml \
    --set kiali.hub=quay.io/kiali \
    --set kiali.tag=v1.26 \
    --set kiali.image=kiali \
    --set global.grafanaNamespace=infra \
    --set kiali.dashboard.auth.strategy=openid \
    --set kiali.dashboard.signing_key=$(openssl rand -hex 16) \
    --set kiali.dashboard.jaegerURL=https://tracing.develop.in.quid.com/jaeger \
    --set kiali.dashboard.jaegerInClusterURL=http://tracing/jaeger \
    --set kiali.dashboard.grafanaURL=https://grafana.develop.in.quid.com \
    --set kiali.dashboard.grafanaInClusterURL=http://po-grafana.infra.svc \
    --set kiali.prometheusAddr=http://po-kube-prometheus-stack-prometheus.infra.svc:9090 \
    --set kiali.createDemoSecret=false \
    -f ${ISTIO_SRC_DIR}/istio/values.kiali.yaml \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/istio-telemetry/kiali
kubectl apply -f ${ISTIO_SRC_DIR}/istio/ingress/kiali-ingress.yaml -n istio-system
```
### tracing
```bash
helm upgrade --install tracing \
    --namespace istio-system \
    -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/global.yaml \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/istio-telemetry/tracing
kubectl apply -f ${ISTIO_SRC_DIR}/istio/ingress/tracing-ingress.yaml -n istio-system
```
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
# Useful Command
### dump components config in default profile
```bash
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path components default
```
### dump base component config and values in default profile
```bash
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path components.base default
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path values.base default
```
### dump pilot component config and values in default profile
```bash
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path components.pilot default
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path values.pilot default
```
### dump ingressGateways component config and values in default profile
```
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path components.ingressGateways default
${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/istioctl profile dump --config-path values.gateways.istio-ingressgateway default
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
* [kiali_cr.yaml](https://github.com/kiali/kiali-operator/blob/master/deploy/kiali/kiali_cr.yaml)
