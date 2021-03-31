### Installation

#### Patch ([issue 1490](https://github.com/kyverno/kyverno/issues/1490))
```bash
export VERTAG=v1.3.4
git clone -b ${VERTAG} --depth 1 https://github.com/kyverno/kyverno
cd kyverno && patch -p1 < ../kyverno.patch
make docker-build-all-amd64 REGISTRY=my-registry
# INIT CONTAINER
docker push my-registry/kyverno/kyvernopre:${VERTAG}
docker push my-registry/kyverno/kyverno:${VERTAG}
docker push my-registry/kyverno/kyverno-cli:${VERTAG}
```
#### Install
```bash
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

helm upgrade --install kyverno \
  -n kyverno \
  --create-namespace \
  -f ./values.yaml \
  kyverno/kyverno
```

### Uninstall
```bash
helm uninstall kyverno -n kyverno
# delete crd
kubectl delete -f https://raw.githubusercontent.com/kyverno/kyverno/main/definitions/release/install.yaml -n kyverno
```

### Troubleshooting
#### check kyverno webhook
```bash
kubectl get validatingwebhookconfigurations,mutatingwebhookconfigurations
 NAME                                                                                                  WEBHOOKS   AGE
 validatingwebhookconfiguration.admissionregistration.k8s.io/kyverno-policy-validating-webhook-cfg     1          46m
 validatingwebhookconfiguration.admissionregistration.k8s.io/kyverno-resource-validating-webhook-cfg   1          46m

 NAME                                                                                              WEBHOOKS   AGE
 mutatingwebhookconfiguration.admissionregistration.k8s.io/kyverno-policy-mutating-webhook-cfg     1          46m
 mutatingwebhookconfiguration.admissionregistration.k8s.io/kyverno-resource-mutating-webhook-cfg   1          46m
 mutatingwebhookconfiguration.admissionregistration.k8s.io/kyverno-verify-mutating-webhook-cfg     1          46m
```
kubectl get mutatingwebhookconfiguration
#### check if available for apiservice is false
```bash
kubectl get apiservice
kubectl api-resources
```
#### check api response
```bash
kubectl get --raw /apis/external.metrics.k8s.io/v1beta1
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1
```

### Reference
* [kyverno](https://github.com/kyverno/kyverno)
* [Generate Resources](https://kyverno.io/docs/writing-policies/generate/)
* [policy management with Kyverno](https://aws.amazon.com/blogs/containers/easy-as-one-two-three-policy-management-with-kyverno-on-amazon-eks/)
* [issue 1481](https://github.com/kyverno/kyverno/issues/1481)
* [issue 1490](https://github.com/kyverno/kyverno/issues/1490)
