kubectl label ns istio-debug istio-injection-
kubectl label ns istio-debug istio-injection=enabled
kubectl get ns istio-debug --show-labels
kubectl rollout restart -n istio-debug deploy nginx-proxy
kubectl get pods -n istio-debug -l app=nginx-proxy
