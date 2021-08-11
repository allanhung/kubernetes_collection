### Installation
```bash
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm repo update

# Install chart
helm upgrade --install actions-runner-controller \
  --namespace github \
  --create-namespace \
  -f values.yaml \
  actions-runner-controller/actions-runner-controller
```

### Reference
* [actions-runner-controller](https://github.com/actions-runner-controller/actions-runner-controller/)
* [PAT Permission](https://github.com/actions-runner-controller/actions-runner-controller#deploying-using-pat-authentication)
