# kube2ram

## Aliyun configuration

<https://github.com/AliyunContainerService/kube2ram#configuration>


## Build image and push image
```bash
docker build -t my-docker-registry/kube2ram:1.0.3 .
docker push my-docker-registry/kube2ram:1.0.3
```

## Installation
```bash
export DRIVER=flannel
helm upgrade --install kube2ram \
    --namespace infra \
    -f ./values.yaml \
    -f ./values.${DRIVER}.yaml \
    ./
```

## go module
```bash
RUN go mod init github.com/AliyunContainerService/kube2ram
RUN go mod tidy
RUN sed -i -e "s#k8s.io/api.*#k8s.io/api v0.17.3#g" -e "s#k8s.io/apimachinery.*#k8s.io/apimachinery v0.17.3#g" -e "s#k8s.io/client-go.*#k8s.io/client-go v0.17.3#g" go.mod
RUN go mod tidy
```

## Debug
```bash
    ram.aliyuncs.com/role: kube2ram-arn
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  annotations:
    ram.aliyuncs.com/role: example-role
  name: kube2ram-test
spec:
  containers:
  - name: centos
    image: centos
    args: ["tail", "-f", "/dev/null"]
EOF
kubectl exec -ti kube2ram-test bash
curl -w "%{http_code}\n" http://100.100.100.200/latest/meta-data/ram/security-credentials/
```
