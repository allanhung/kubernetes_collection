### Installation

helm repo add dex https://charts.dexidp.io
helm repo update

helm upgrade --install dex \
    --namespace dex \
    -f values.yaml \
    -f values.example.yaml \
    dex/dex
``` 
