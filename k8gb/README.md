# install k8gb
helm repo add k8gb https://www.k8gb.io
helm repo update k8gb
helm pull --untar k8gb/k8gb
cd k8gb && patch -p1 --no-backup < ../helm.patch && cd ..
helm template --release-name k8gb -f values.yaml -f values.us.yaml k8gb/ > k8gb.us.yaml
helm template --release-name k8gb -f values.yaml -f values.eu.yaml k8gb/ > k8gb.eu.yaml

# install podinfo
helm repo add podinfo https://stefanprodan.github.io/podinfo
helm repo update podinfo
helm template --release-name podinfo --set ui.message="us" podinfo/podinfo

# create gslb resource
cat << EOF | kubectl apply -f -
apiVersion: k8gb.absa.oss/v1beta1
kind: Gslb
metadata:
  name: podinfo
spec:
  ingress:
    ingressClassName: nginx
    rules:
      - host: podinfo.cloud.example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: podinfo # This should point to Service name of testing application
                port:
                  name: http

  strategy:
    type: roundRobin
EOF

# test external-dns

https://github.com/kubernetes-sigs/external-dns/blob/master/docs/contributing/crd-source.md

kubectl create deploy k8gb-extdns --image=registry.k8s.io/external-dns/external-dns:v0.13.5 -- tail -f /dev/null
kubectl set sa deploy k8gb-extdns k8gb
kubectl exec -ti deploy/k8gb-extdns /bin/sh
external-dns --source crd --crd-source-apiversion externaldns.k8s.io/v1alpha1  --crd-source-kind DNSEndpoint --provider inmemory --once --dry-run
export DNSIMPLE_OAUTH=X7cwvkeRPz9sYkz2IHWc1UnfKtP0fYON
export DNSENV=staging
external-dns --provider=dnsimple --source=crd --domain-filter=quid.com --policy=sync --managed-record-types=A --managed-record-types=CNAME --managed-record-types=NS --annotation-filter=k8gb.absa.oss/dnstype=extdns --txt-owner-id=k8gb-${DNSENV} --once --dry-run --log-level=debug


