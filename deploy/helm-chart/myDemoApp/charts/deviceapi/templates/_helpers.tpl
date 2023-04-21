{{/*
Expand the name of the chart.
*/}}
{{- define "deviceapi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "deviceapi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "deviceapi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "deviceapi.labels" -}}
helm.sh/chart: {{ include "deviceapi.chart" . }}
{{ include "deviceapi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "deviceapi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "deviceapi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "deviceapi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "deviceapi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "deviceapi.mount.init.wallet" -}}
# for init container
- name: wallet
  mountPath: /usr/lib/oracle/19.3/client64/lib/network/admin/
  readOnly: true
{{- end -}}

{{- define "deviceapi.mount.service.wallet" -}}
# for service container
- name: wallet
  mountPath: /wallet
  readOnly: true
- name: {{ include (printf "%s.fullname" .Chart.Name) . }}-config
  mountPath: /config
  readOnly: true
{{- end -}}

{{/* CONTAINER VOLUME TEMPLATE */}}
{{- define "deviceapi.init.volumes" -}}
{{- $wallet := .Values.global.oadbWalletSecret -}}
# local wallet
- name: wallet
  secret:
    secretName: {{ $wallet }}
# service init configMap
- name: initdb
  configMap:
    name: {{ include (printf "%s.fullname" .Chart.Name) . }}-init
    items:
    - key: atp.init.sql
      path: service.sql
{{- end -}}

{{/* CONTAINER VOLUME TEMPLATE */}}
{{- define "deviceapi.service.volumes" -}}
{{- $wallet := .Values.global.oadbWalletSecret -}}
# local wallet
- name: wallet
  secret:
    secretName: {{ $wallet }}
# service init configMap
- name: {{ include (printf "%s.fullname" .Chart.Name) . }}-config
  configMap:
    name: {{ include (printf "%s.fullname" .Chart.Name) . }}-config
{{- end -}}

{{/* OADB Wallet BINDING initContainer */}}
{{- define "deviceapi.init.wallet" -}}
# OSB Wallet Binding decoder
- name: decode-binding
  image: oraclelinux:7-slim
  command: ["/bin/sh","-c"]
  args: 
  - for i in `ls -1 /tmp/wallet | grep -v user_name`; do cat /tmp/wallet/$i | base64 --decode > /wallet/$i; done; ls -l /wallet/*;
  volumeMounts:
    - name: wallet-binding
      mountPath: /tmp/wallet
      readOnly: true
    - name: wallet
      mountPath: /wallet
      readOnly: false
{{- end -}}

{{/* OADB Connection environment */}}
{{- define "deviceapi.oadb.connection" -}}
{{- $connectionSecret := default .Values.global.oadbConnectionSecret -}}
{{- $credentialSecret := default .Values.secrets.oadbUserSecret -}}
- name: OADB_USER
  valueFrom:
    secretKeyRef:
      name: {{ $credentialSecret }}
      key: oadb_user
- name: OADB_PW
  valueFrom:
    secretKeyRef:
      name: {{ $credentialSecret }}
      key: oadb_pw
- name: OADB_SERVICE
  valueFrom:
    secretKeyRef:
      name: {{ $connectionSecret }}
      key: oadb_service
{{- end -}}

{{/* OADB ADMIN environment */}}
{{- define "deviceapi.oadb.admin" -}}
{{- $adminSecret := default .Values.oadbAdminSecret | default .Values.global.oadbAdminSecret -}}
- name: OADB_ADMIN_PW
  valueFrom:
    secretKeyRef:
      name: {{ $adminSecret }}
      key: oadb_admin_pw
{{- end -}}

{{/* OADB dbtools mount template */}}
{{- define "deviceapi.mount.initdb" -}}
- name: initdb
  mountPath: /work/
{{- end -}}

{{/* OADB Wallet mount */}}
{{- define "deviceapi.mount.wallet" -}}
# for init container
- name: wallet
  mountPath: /wallet/
  readOnly: true
{{- end -}}