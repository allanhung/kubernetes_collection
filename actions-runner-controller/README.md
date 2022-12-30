### Installation
```bash
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm repo update

# Install chart
helm upgrade --install actions-runner-controller \
  --namespace github \
  --create-namespace \
  -f values.yaml \
  --set authSecret.github_app_id=myAppId
  --set authSecret.github_app_installation_id=myInstallationId
  --set authSecret.github_app_private_key=myPrivateKey
  --set githubWebhookServer.secret.github_webhook_secret_token=myWebhookSecretToken
  actions-runner-controller/actions-runner-controller
```

### Config GitHub App
* GitHub App name: ActionsRunner
* https://github.com/organizations/:org/settings/apps/new
* Home Page URL: http://github.com/actions-runner-controller/actions-runner-controller
* Webhook URL: https://actionsrunner.mydomain.com
* Webhook secret: fcf186c0cd0d2d781fe0ada7621cc3783ebccfdf # openssl rand -hex 20

### GitHub App info
App ID: 123456
Client ID: Ii1.d0c07ea307112f72
Client Secret: 22c4fb6bd05bd2099754fdd1b70d01df0ec97545
https://github.com/organizations/myorg/settings/installations/19358472

### Actions
* [Webhook debug](requestcatcher.com)
* [Get Tag or SHA](https://github.com/marketplace/actions/get-tag-or-sha)

### Actions Variable
* [Context availability](https://docs.github.com/en/actions/reference/context-and-expression-syntax-for-github-actions#context-availability)
* [Default environment variables](https://docs.github.com/en/actions/reference/environment-variables#default-environment-variables)

### Reference
* [actions-runner-controller](https://github.com/actions-runner-controller/actions-runner-controller/)
* [PAT Permission](https://github.com/actions-runner-controller/actions-runner-controller#deploying-using-pat-authentication)
* [Deploying Using GitHub App Authentication](https://github.com/actions-runner-controller/actions-runner-controller#deploying-using-github-app-authentication)
* [actions-runner helm chart](https://github.com/actions/actions-runner-controller/tree/master/contrib/examples/actions-runner)
