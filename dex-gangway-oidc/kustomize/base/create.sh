gomplate -d values=./values.yaml -f dex-config.yaml.tmpl -o dex-config.yaml
gomplate -d values=./values.yaml -f dex-ingress.yaml.tmpl -o dex-ingress.yaml
gomplate -d values=./values.yaml -f gangway-config.yaml.tmpl -o gangway-config.yaml
gomplate -d values=./values.yaml -f gangway-deployment.yaml.tmpl -o gangway-deployment.yaml
gomplate -d values=./values.yaml -f gangway-ingress.yaml.tmpl -o gangway-ingress.yaml
gomplate -d values=./values.yaml -f oidc-deployment.yaml.tmpl -o oidc-deployment.yaml
gomplate -d values=./values.yaml -f oidc-ingress.yaml.tmpl -o oidc-ingress.yaml
gomplate -d values=./values.yaml -f kustomization.yaml.tmpl -o kustomization.yaml
kustomize build . > my-dex.yaml
./clean.sh
