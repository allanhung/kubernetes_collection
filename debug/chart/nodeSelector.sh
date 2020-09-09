cat >> chart/templates/all.yaml << EOF
{{- if .Values.nodeSelector }}
      nodeSelector:
{{ toYaml .Values.nodeSelector | indent 8 }}
{{- end }}
EOF
