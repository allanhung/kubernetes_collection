# Postgresql on kubernetes
This project helps deploy postgresql on kubernetes base on postgresql offical image.

# setting
See the [PostgreSQL Docker Official Image documentation](https://hub.docker.com/_/postgres)

# How to use
```
# generate certificate
cd ./base/ssl && ./gencert.sh && cd ../..
kustomize build base | kubectl apply -f -
```
