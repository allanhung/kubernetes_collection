### Demo
* build with docker
```bash
kubectl apply -f docker-socket.yaml
kubectl exex -ti docker -- sh
git clone https://github.com/allanhung/kaniko-demo
docker build .
```
* build with kaniko
```bash
kubectl create secret docker-registry regcred \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=allanhung \
  --docker-password=xxx

export VERSION=1.0.2
gsed -i -e "s/devops-toolkit:.*/devops-toolkit:${VERSION}\"]/g" kaniko-git.yaml
kubectl get pods kaniko && kubectl delete pods kaniko
kubectl apply -f kaniko-git.yaml && sleep 1 && kubectl logs -f kaniko
```

### Reference
[demo](https://www.youtube.com/watch?v=EgwVQN6GNJg)
[demo sample](https://github.com/vfarcic/kaniko-demo)
[pushing-to-docker-hub](https://github.com/GoogleContainerTools/kaniko#pushing-to-docker-hub)
