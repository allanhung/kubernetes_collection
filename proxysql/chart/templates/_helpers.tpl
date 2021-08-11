{{- define "proxysql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "proxysql.fullname" -}}
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

{{- define "proxysql.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "proxysql.matchLabels" -}}
app: {{ template "proxysql.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{- define "proxysql.metaLabels" -}}
version: {{ .Chart.AppVersion }}
chart: {{ template "proxysql.chart" . }}
{{- end -}}

{{- define "proxysql.labels" -}}
{{ include "proxysql.matchLabels" . }}
{{ include "proxysql.metaLabels" . }}
{{- end -}}
