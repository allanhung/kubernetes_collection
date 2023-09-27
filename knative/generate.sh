#!/bin/bash

usage () {
  echo "usage: $0 -v Version"
  echo "   -v knative version"
}

while getopts 'hv:' opt; do
  case "$opt" in
    v)
      KNATIVE_VERSION=${OPTARG}
      ;;
    ?|h)
      usage
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if [[ -z ${KNATIVE_VERSION} ]]; then
    usage
    exit 1
fi

# generate configmap
generate_cm() {
  # helm doesn't allow hyphens in variable names
  VARNAME=$(echo $2 | sed "s/-//")
  COMPNAME=$(echo $3 | sed "s/-//")
  case $2 in
    "autoscaler"|"logging"|"observability"|"tracing")
      COMPLABELS=$2
      ;;
    "network")
      COMPLABELS="networking"
      ;;
    "istio")
      COMPLABELS=$'net-istio\n    networking.knative.dev/ingress-provider: istio'
      ;;
    "certmanager")
      COMPLABELS=$'net-certmanager\n    networking.knative.dev/certificate-provider: cert-manager'
      ;;
    *)
      COMPLABELS="controller"
      ;;
  esac
  cat > templates/$4.yaml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: config-$2
  namespace: knative-serving
  labels:
    app.kubernetes.io/component: $COMPLABELS
    app.kubernetes.io/name: knative-serving
    app.kubernetes.io/version: "$1"
data:
  {{- tpl (toYaml .Values.$COMPNAME.config.$VARNAME) . | nindent 2 }}
EOF
}
export -f generate_cm

gsed -i -e "s/appVersion:.*/appVersion: ${KNATIVE_VERSION}/g" Chart.yaml
mkdir -p templates sources crds
rm -rf templates/*

# crds
curl -Lo crds/serving-crds.yaml https://github.com/knative/serving/releases/download/knative-v${KNATIVE_VERSION}/serving-crds.yaml

# core
curl -Lo sources/serving-core.yaml https://github.com/knative/serving/releases/download/knative-v${KNATIVE_VERSION}/serving-core.yaml

# hpa
curl -Lo sources/serving-hpa.yaml https://github.com/knative/serving/releases/download/knative-v${KNATIVE_VERSION}/serving-hpa.yaml

# istio
curl -Lo sources/net-istio.yaml https://github.com/knative/net-istio/releases/download/knative-v${KNATIVE_VERSION}/net-istio.yaml

# cert-manager
curl -Lo sources/cert-manager.yaml  https://github.com/knative/net-certmanager/releases/download/knative-v${KNATIVE_VERSION}/release.yaml

# group by kind
grep -e '^kind:' sources/serving-core.yaml | grep -v -e 'CustomResourceDefinition\|ConfigMap\|Namespace' | sort | uniq | awk {'print "yq \047select(.kind != null and .kind == \""$2"\")\047 < sources/serving-core.yaml > templates/"$2".yaml"'} > sources/generate_template.sh

grep -e '^kind:' sources/net-istio.yaml | grep -v -e 'CustomResourceDefinition\|ConfigMap\|Namespace' | sort | uniq | sed -e 's#"##g' | awk {'print "yq \047select(.kind != null and .kind == \""$2"\")\047 < sources/net-istio.yaml > templates/net-istio-"$2".yaml"'} >> sources/generate_template.sh

grep -e '^kind:' sources/cert-manager.yaml | grep -v -e 'CustomResourceDefinition\|ConfigMap\|Namespace\|Certificate\|ClusterIssuer' | sort | uniq | sed -e 's#"##g' | awk {'print "yq \047select(.kind != null and .kind == \""$2"\")\047 < sources/cert-manager.yaml > templates/cert-manager-"$2".yaml"'} >> sources/generate_template.sh

bash -x sources/generate_template.sh

# hpa
cp sources/serving-hpa.yaml templates/

# group by configmap name
export -f generate_cm
grep -e '^kind: ConfigMap' -A 2 sources/serving-core.yaml | grep -e '^  name:'| sort | uniq | awk -F"config-" {'print $2'} | xargs -I{} bash -c "generate_cm ${KNATIVE_VERSION} {} knative ConfigMap-{}"

grep -e '^kind: ConfigMap' -A 2 sources/net-istio.yaml | grep -e '^  name:'| sort | uniq | awk -F"config-" {'print $2'} | xargs -I{} bash -c "generate_cm ${KNATIVE_VERSION} {} net-istio net-istio-ConfigMap-{}"

grep -e '^kind: ConfigMap' -A 2 sources/cert-manager.yaml | grep -e '^  name:'| sort | uniq | awk -F"config-" {'print $2'} | xargs -I{} bash -c "generate_cm ${KNATIVE_VERSION} {} cert-manager cert-manager-ConfigMap-{}"

yq -i -e 'select(.metadata.name == "webhook") .spec.template.spec.containers[0].livenessProbe.initialDelaySeconds = "{{ .Values.knative.webhook.initialDelaySeconds }}"' templates/Deployment.yaml
gsed -i -e "s#'{{ .Values.knative.webhook.initialDelaySeconds }}'#{{ .Values.knative.webhook.initialDelaySeconds }}#g" templates/Deployment.yaml

yq -i -e 'select(.apiVersion == "autoscaling/v2beta2") .apiVersion = "autoscaling/v2"' templates/HorizontalPodAutoscaler.yaml

yq -i -e 'select(.metadata.name == "knative-local-gateway") .spec.ports[1] = {"name": "http8080", "port": 8080, "targetPort": 8081}' templates/net-istio-Service.yaml
yq -i -e 'select(.spec.selector.istio == "ingressgateway") .spec.selector.istio = "{{ .Values.netistio.selector }}"' templates/net-istio-Service.yaml
yq -i -e 'select(.spec.selector.istio == "ingressgateway") .spec.selector.istio = "{{ .Values.netistio.selector }}"' templates/net-istio-Gateway.yaml
