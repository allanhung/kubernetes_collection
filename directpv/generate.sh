#!/bin/bash

mkdir -p templates sources crds
rm -rf templates/*
kubectl directpv install -o yaml > sources/directpv-install.yaml

## delete status
yq -i -e 'del(.status)' sources/directpv-install.yaml
## delete creationTimestamp
yq -i -e 'del(.metadata.creationTimestamp)' sources/directpv-install.yaml
yq -i -e 'del(.spec.template.metadata.creationTimestamp)' sources/directpv-install.yaml
## replace namespace
yq -i -e 'select(.metadata.namespace != null) .metadata.namespace = "{{ .Release.Namespace }}"' sources/directpv-install.yaml
yq -i -e 'select(.kind == "ClusterRoleBinding" or .kind == "RoleBinding") .subjects[0].namespace = "{{ .Release.Namespace }}"' sources/directpv-install.yaml
yq -i -e 'del(.spec.template.metadata.namespace)' sources/directpv-install.yaml

# group by kind
grep -e '^kind:' sources/directpv-install.yaml | grep -v -e 'CustomResourceDefinition\|Namespace' | sort | uniq | awk {'print "yq \047select(.kind != null and .kind == \""$2"\")\047 < sources/directpv-install.yaml > templates/"$2".yaml"'} > sources/generate_template.sh
# crds
grep -e '^kind:' sources/directpv-install.yaml | grep 'CustomResourceDefinition' | sort | uniq | awk {'print "yq \047select(.kind != null and .kind == \""$2"\")\047 < sources/directpv-install.yaml > crds/"$2".yaml"'} >> sources/generate_template.sh

bash -x sources/generate_template.sh
patch -p1 --no-backup < directpv.patch
