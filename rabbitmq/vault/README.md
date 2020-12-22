## Patch Rabbitmq docker image to support vault [vault-secrets-webhook](https://github.com/banzaicloud/bank-vaults/tree/master/charts/vault-secrets-webhook)
Due to the helm charts create the configmap during [install](https://github.com/bitnami/charts/blob/master/bitnami/rabbitmq/values.yaml#L188). That may cause the rabbitmq user become 'vault:<my-vault-path>#,<my-vault-key>'. Need to patch to create the correct user when initialize.

```bash
export TAG=3.8.9-debian-10-r43
git clone -b ${TAG} --depth 1 https://github.com/bitnami/bitnami-docker-rabbitmq
cd bitnami-docker-rabbitmq/3.8/debian-10 && patch -p1 < vault.patch
docker build -t <my-docker-repo>/rabbitmq:${TAG} . && docker push <my-docker-repo>/rabbitmq:${TAG}
```
