### Upgrade / Install
```bash
test -d argo-helm || git clone --depth 1 https://github.com/argoproj/argo-helm
gsed -i -e "s#apiextensions.k8s.io/v1\$#apiextensions.k8s.io/v1beta1#g" ./argo-helm/charts/argo-events/crds/*

helm upgrade --install argo-events \
  -n argo-events \
  --create-namespace \
  ./argo-helm/charts/argo-events/

rm -rf ./argo-helm
```

### Reference
* [argo helm chart](https://github.com/argoproj/argo-helm)
* [argo event sources](https://github.com/argoproj/argo-events/blob/master/examples/event-sources)
* [argo event specs](https://github.com/argoproj/argo-events/blob/stable/api/event-source.md#eventsourcespec)
* [Argo Events: Event Source 源碼分析](https://zhuanlan.zhihu.com/p/350542301)
