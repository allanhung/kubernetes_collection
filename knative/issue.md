https://github.com/knative/serving/issues/6346
https://github.com/knative/serving/issues/7005

kubectl get ksvc -n default
NAME            URL                                              LATESTCREATED         LATESTREADY           READY     REASON
helloworld-go   http://helloworld-go.default.svc.cluster.local   helloworld-go-00001   helloworld-go-00001   Unknown   IngressNotConfigured

kubectl -n knative-serving logs controller-5f64fb5c49-2bqj9 |grep -i error

{"severity":"error","timestamp":"2022-08-04T14:28:08.166Z","logger":"controller","caller":"controller/controller.go:566","message":"Reconcile error","commit":"3666ce7","knative.dev/pod":"controller-5f64fb5c49-2bqj9","knative.dev/controller":"knative.dev.serving.pkg.reconciler.route.Reconciler","knative.dev/kind":"serving.knative.dev.Route","knative.dev/traceid":"5b8dfb38-4a60-4fcd-847b-5cd805f31a61","knative.dev/key":"default/helloworld-go","duration":0.002890678,"error":"failed to create Ingress: create not allowed while custom resource definition is terminating","stacktrace":"knative.dev/pkg/controller.(*Impl).handleErr\n\tknative.dev/pkg@v0.0.0-20220705130606-e60d250dc637/controller/controller.go:566\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20220705130606-e60d250dc637/controller/controller.go:543\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20220705130606-e60d250dc637/controller/controller.go:491"}
{"severity":"info","timestamp":"2022-08-04T14:28:08.166Z","logger":"controller.event-broadcaster","caller":"record/event.go:285","message":"Event(v1.ObjectReference{Kind:\"Route\", Namespace:\"default\", Name:\"helloworld-go\", UID:\"327e7ba1-998c-4e52-ac49-ebdda792b50e\", APIVersion:\"serving.knative.dev/v1\", ResourceVersion:\"2320787050\", FieldPath:\"\"}): type: 'Warning' reason: 'InternalError' failed to create Ingress: create not allowed while custom resource definition is terminating","commit":"3666ce7","knative.dev/pod":"controller-5f64fb5c49-2bqj9"}


https://github.com/kubernetes/kubernetes/issues/60538

kubectl get crds |grep knative |awk {'print $1'}|xargs -I{} sh -c "echo {} && kubectl get crds {} -o yaml | grep Terminating"
certificates.networking.internal.knative.dev
clusterdomainclaims.networking.internal.knative.dev
configurations.serving.knative.dev
domainmappings.serving.knative.dev
images.caching.internal.knative.dev
ingresses.networking.internal.knative.dev
    type: Terminating
metrics.autoscaling.internal.knative.dev
podautoscalers.autoscaling.internal.knative.dev
revisions.serving.knative.dev
routes.serving.knative.dev
serverlessservices.networking.internal.knative.dev
services.serving.knative.dev

kubectl patch crd/ingresses.networking.internal.knative.dev -p '{"metadata":{"finalizers":[]}}' --type=merge
