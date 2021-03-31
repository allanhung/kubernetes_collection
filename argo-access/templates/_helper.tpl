{{/* Set of labels */}}

{{- define "labels" -}}
release: "{{ .Release.Name }}"
version: "{{ .Chart.AppVersion }}"
chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}
