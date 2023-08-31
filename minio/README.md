helm repo add minio https://charts.min.io/
helm repo update


https://docs.min.io/minio/baremetal/monitoring/metrics-alerts/collect-minio-metrics-using-prometheus.html?ref=con#visualize-collected-metrics

https://github.com/minio/minio/tree/master/helm/minio


kubectl create deploy mc --image=minio/mc -- tail -f /dev/null
kubectl exec -ti deploy/mc bash
mc config host add minio-src http://172.20.5.38:9000 puxCpd2k46zMqCnGLnVgTK2AYUCfwj7n WZWw6DVDjgxVnQfMdYqEEBUTzLdxU5uD --api s3v4
mc config host add minio-dst http://172.20.189.119:9000 puxCpd2k46zMqCnGLnVgTK2AYUCfwj7n WZWw6DVDjgxVnQfMdYqEEBUTzLdxU5uD --api s3v4
mc ls minio-src
mc ls minio-dst
mc mirror -w minio-src minio-dst
