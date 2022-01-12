{{- define "subspace.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "subspace.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "subspace.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "subspace.image" -}}
{{- $tag := (coalesce .Values.image.tag .Chart.AppVersion) | toString -}}
{{- if .Values.image.registry -}}
{{- printf "%s/%s:%s" .Values.image.registry .Values.image.repository $tag -}}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end -}}
{{- end -}}

{{- define "subspace.matchLabels" -}}
app: {{ template "subspace.name" . }}
release: {{ .Release.Name }}
version: {{ .Chart.AppVersion }}
{{- end -}}

{{- define "subspace.metaLabels" -}}
chart: {{ template "subspace.chart" . }}
{{- end -}}

{{- define "subspace.labels" -}}
{{ include "subspace.metaLabels" . }}
{{ include "subspace.matchLabels" . }}
{{- end -}}

{/* Allow KubeVersion to be overridden. */}}
{{- define "subspace.ingress.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/* Get Ingress API Version */}}
{{- define "subspace.ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19.x" (include "subspace.ingress.kubeVersion" .)) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}

{{/* Check Ingress stability */}}
{{- define "subspace.ingress.isStable" -}}
  {{- eq (include "subspace.ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{/* Check Ingress supports pathType */}}
{{/* pathType was added to networking.k8s.io/v1beta1 in Kubernetes 1.18 */}}
{{- define "subspace.ingress.supportsPathType" -}}
  {{- or (eq (include "subspace.ingress.isStable" .) "true") (and (eq (include "subspace.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18.x" (include "subspace.ingress.kubeVersion" .))) -}}
{{- end -}}
