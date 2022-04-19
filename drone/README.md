# Drone CI/CD

This directory contains a CI/CD pipeline setup using Drone deployed to Kubernetes.

## Setup
The Drone Server and Runner is deployed by terraform using helm charts. The values to configure the server and runner can be seen in: `./terraform/drone-values.yaml` and `drone-runner-kube-values.yaml`.

## To adapt to another project:
- Edit `./terraform/drone-values.yaml` by setting `DRONE_SERVER_HOST` to the host where incoming messages will arrive (e.g. the IP or the Domain).
- Edit `./terraform/drone-values.yaml` by setting `DRONE_USER_CREATE` to `"username:<githubusername>,admin:true"`
- Create file `./terraform/drone-secret.yaml` containing:

```
apiVersion: v1
kind: Secret
metadata:
  name: drone-secret
  namespace: drone
type: Opaque
stringData:
  DRONE_GITHUB_CLIENT_ID: <client-id>
  DRONE_GITHUB_CLIENT_SECRET: <client-secret>
  DRONE_RPC_SECRET: <some-random-secret>
```

- Add Drone environment variables through the UI called GITHUB_USERNAME (containing the github username) and GITHUB_TOKEN (containing an access token to the github user).

## Deploy

Run: `cd terraform && terraform apply`

This will deploy the drone server and runner to the cluster. The Drone UI can then be accessed through the `DRONE_SERVER_HOST` previously defined. By logging in with a github account the Github repository can be configured.