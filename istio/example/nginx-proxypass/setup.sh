export NGINXHOST=$(kubectl get pods -l app=nginx-proxy |grep nginx | grep -v Terminating | awk {'print $1'})
kubectl exec -c centos ${NGINXHOST} -- yum install -y nginx vim
kubectl cp nginx.conf ${NGINXHOST}:/etc/nginx/nginx.conf -c centos
kubectl exec ${NGINXHOST} -c centos nginx
echo "kubectl exec -ti ${NGINXHOST} -c centos bash"
