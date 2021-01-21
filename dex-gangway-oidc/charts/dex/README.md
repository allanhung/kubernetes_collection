### Installation

git clone --depth 1 https://github.com/helm/charts
patch -p1 < ingress.patch
helm upgrade --install dex \
    --namespace dex \
    -f values.yaml \
    -f values.example.yaml \
    charts/stable/dex
``` 
