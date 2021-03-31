### Installation
#### Patch
```bash
export VER=6.4.0
git clone --depth 1 -b ${VER} https://github.com/external-secrets/kubernetes-external-secrets
patch -p1 < Dockerfile.patch && cp swagger-fluent.patch kubernetes-external-secrets
cd kubernetes-external-secrets &&  docker build -t my-registry/external-secrets/kubernetes-external-secrets:${VER} .
```
#### Install
```bash
helm repo add external-secrets https://external-secrets.github.io/kubernetes-external-secrets
helm repo update

helm upgrade --install kes \
  -n kubernetes-external-secrets \
  --create-namespace \
  -f ./values.yaml \
  external-secrets/kubernetes-external-secrets
```

### Example
```bash
kubectl create secret generic my-secret --from-literal=my-key=my-value --from-literal=secretKey=$(vault read -format=json secret/my-secret-path  | jq -r '.data.secretKey')

cat << EOF | kubectl apply -f -
apiVersion: kubernetes-client.io/v1
kind: ExternalSecret
metadata:
  name: my-secret
spec:
  backendType: vault
  data:
  - name: secretKey
    key: secret/my-secret-path
    property: secretKey
  template:
    data:
      my-key: my-value
  vaultMountPoint: my-vault-auth
  vaultRole: my-vault-role
EOF
```

### Reference
* [Kubernetes External Secrets](https://tw.godaddy.com/engineering/2019/04/16/kubernetes-external-secrets)
* [external-secrets](https://github.com/external-secrets/kubernetes-external-secrets)
* [Argo CD Secret Management](https://argo-cd.readthedocs.io/en/stable/operator-manual/secret-management/)
* [Failed to Component](https://github.com/external-secrets/kubernetes-external-secrets/issues/563)
