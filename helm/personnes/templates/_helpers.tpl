{{- define "personnes.secretName" -}}
{{- default "postgres-credentials" .Values.postgres.auth.existingSecret -}}
{{- end -}}

{{- define "personnes.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: personnes
{{- end -}}

{{- define "personnes.selectorLabels" -}}
app.kubernetes.io/name: {{ .component }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
{{- end -}}
