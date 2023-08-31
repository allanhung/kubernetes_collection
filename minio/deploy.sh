helm upgrade --install minio \
  --namespace minio \
  --create-namespace \
  -f values.yaml \
  minio/minio
