# Testing Tool

A tool to test the deployment time and fault tolerance of CI/CD pipelines.

## Versioning

- A new commit with a new version in .config.
- The integration tool builds and pushes the new images.
- Once completed the helm-chart versioning will be updated
  - DRONE: Doesn't need to commit versioning to git as its deployed in cluster
  - ARGO+ARGO: Change should be committed to separate repository -> Will not trigger integration.
  - Jenkinsx: Idk
  - ARGO+GOCD: Could also live inside a separate repository. 