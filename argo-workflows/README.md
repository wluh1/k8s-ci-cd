https://github.com/argoproj/argo-helm

## Setup

- Install argo CLI from <https://github.com/argoproj/argo-workflows/releases/tag/v3.3.1>

- Create a Kubernetes secret to contain the Github credentials:
```
apiVersion: v1
kind: Secret
metadata:
  name: github-creds
  namespace: argo
type: Opaque
stringData:
  username: <github_username>
  token: <github_token>
```

- Add webhook to github with a shared secret


## Argo UI
The argo UI can be reached from the nginx ingress under the route `/argo`. The UI requires a token which can be fetched using the ArgoCLI with the command `argo auth token`.
