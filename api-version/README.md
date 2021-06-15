### Issue 
* [No matches for kind "Ingress" in version "networking.k8s.io/v1"](https://github.com/kubernetes/kubernetes/issues/90077)

### Fix
* _helpers.tpl
```yaml
{/* Allow KubeVersion to be overridden. */}}
{{- define "ingress.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/* Get Ingress API Version */}}
{{- define "ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19.x" (include "ingress.kubeVersion" .)) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}
```
* ingress
```yaml
apiVersion: {{ include "ingress.apiVersion" . }}
```
