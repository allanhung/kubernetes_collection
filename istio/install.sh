export ISTIO_VER=1.11.0
export ISTIO_SRC_DIR=~/Downloads/git/kubernetes_collection
export OS=osx
export CLUSTERNAME=develop-a
export REGION=us-east-1
export MESHID=develop
export DOCKERHUB=docker.io/istio
mkdir -p ${ISTIO_SRC_DIR}/istio/charts
mkdir -p ${ISTIO_SRC_DIR}/istio/download
mkdir -p ${ISTIO_SRC_DIR}/istio/${ISTIO_TM_VER}
mkdir -p ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin
mkdir -p ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/config

echo
echo "# ---------------------------------------------------------------------------------------------------------------"
echo "#  Setup istioctl."
echo "# ---------------------------------------------------------------------------------------------------------------"
curl -L -o ${ISTIO_SRC_DIR}/istio/download/istioctl-${ISTIO_VER}-${OS}.tar.gz https://github.com/istio/istio/releases/download/${ISTIO_VER}/istioctl-${ISTIO_VER}-${OS}.tar.gz
tar -zxvf ${ISTIO_SRC_DIR}/istio/download/istioctl-${ISTIO_VER}-${OS}.tar.gz -C ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/bin/

echo
echo "# ---------------------------------------------------------------------------------------------------------------"
echo "#  Generate certificate for mesh."
echo "# ---------------------------------------------------------------------------------------------------------------"
mkdir -p ${ISTIO_SRC_DIR}/istio/certs && cd ${ISTIO_SRC_DIR}/istio/certs
if [ ! -f "${ISTIO_SRC_DIR}/istio/certs/root-ca.conf" ]; then
  make -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/tools/certs/Makefile.selfsigned.mk root-ca
fi
make -f ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/tools/certs/Makefile.selfsigned.mk ${CLUSTERNAME}-${REGION}-cacerts

if [ ! -f "${ISTIO_SRC_DIR}/istio/download/istio-${ISTIO_VER}-linux-arm64.tar.gz" ]; then
  echo
  echo "# ---------------------------------------------------------------------------------------------------------------"
  echo "#  Download istio ${ISTIO_VER} release."
  echo "# ---------------------------------------------------------------------------------------------------------------"
  curl -L -o ${ISTIO_SRC_DIR}/istio/download/istio-${ISTIO_VER}-linux-arm64.tar.gz https://github.com/istio/istio/releases/download/${ISTIO_VER}/istio-${ISTIO_VER}-linux-arm64.tar.gz
  tar -zxvf ${ISTIO_SRC_DIR}/istio/download/istio-${ISTIO_VER}-linux-arm64.tar.gz -C ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}
  mv ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/istio-${ISTIO_VER} ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release
  echo
  echo "# ---------------------------------------------------------------------------------------------------------------"
  echo "#  Patch to support daemonset with istio ingress."
  echo "# ---------------------------------------------------------------------------------------------------------------"
  cd ${ISTIO_SRC_DIR}/istio/${ISTIO_VER} && patch -p1 < ${ISTIO_SRC_DIR}/istio/patch/istio-ingress.patch
fi

echo
echo "# ---------------------------------------------------------------------------------------------------------------"
echo "#  Setup istio CRDs, cluster bindings, cluster resources."
echo "# ---------------------------------------------------------------------------------------------------------------"
helm upgrade --install istio-base \
    --namespace istio-system \
    --create-namespace \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/base

echo
echo "# ---------------------------------------------------------------------------------------------------------------"
echo "#  Setup istiod."
echo "# ---------------------------------------------------------------------------------------------------------------"
helm upgrade --install istiod \
    --namespace istio-system \
    -f ${ISTIO_SRC_DIR}/istio/values.inject.yaml \
    --set global.hub=${DOCKERHUB} \
    --set global.meshID=${MESHID}-mesh \
    --set global.multiCluster.clusterName=${CLUSTERNAME}-${REGION} \
    --set global.network=${MESHID}.${REGION} \
    --set global.proxy.logLevel=warning \
    --set global.accessLogFile=/dev/stdout \
    --set global.jwtPolicy=first-party-jwt \
    --set global.tracer.zipkin.address=jaeger-collector.tracing.svc:9411 \
    --set pilot.traceSampling=1 \
    ${ISTIO_SRC_DIR}/istio/${ISTIO_VER}/release/manifests/charts/istio-control/istio-discovery

echo
echo "# ---------------------------------------------------------------------------------------------------------------"
echo "#  Setup istio ingress gateway."
echo "# ---------------------------------------------------------------------------------------------------------------"
helm upgrade --install istio-ingress-internal \
    --namespace istio-system \
    --set global.hub=${DOCKERHUB} \
    --set global.meshID=${MESHID}-mesh \
    --set global.multiCluster.clusterName=${CLUSTERNAME}-${REGION} \
    --set global.network=${MESHID}.${REGION} \
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
    --namespace istio-system \
    --set global.hub=${DOCKERHUB} \
    --set global.meshID=${MESHID}-mesh \
    --set global.multiCluster.clusterName=${CLUSTERNAME}-${REGION} \
    --set global.network=${MESHID}.${REGION} \
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

echo
echo "# ---------------------------------------------------------------------------------------------------------------"
echo "#  Setup istio service monitor for prometheus operator."
echo "# ---------------------------------------------------------------------------------------------------------------"
helm upgrade --install istio-servicemonitor \
    --namespace istio-system \
    --set serviceMonitor.labels.release=po \
    ${ISTIO_SRC_DIR}/istio/charts/prometheusOperator

echo
echo "# ---------------------------------------------------------------------------------------------------------------"
echo "#  Workaround: dispatch error: http/1.1 protocol error: both 'Content-Length' and 'Transfer-Encoding' are set." 
echo "# ---------------------------------------------------------------------------------------------------------------"

cat << EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: allow-chunked-length
  namespace: istio-system
spec:
  configPatches:
  - applyTo: NETWORK_FILTER
    match:
      listener:
        filterChain:
          filter:
            name: "envoy.filters.network.http_connection_manager"
    patch:
      operation: MERGE
      value:
        typed_config:
          "@type": "type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager"
          http_protocol_options:
            allow_chunked_length: true
EOF
