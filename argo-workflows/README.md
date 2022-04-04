https://github.com/argoproj/argo-helm

kubectl create namespace argo

kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v3.3.1/install.yaml

kubectl create rolebinding default-admin --clusterrole=admin --serviceaccount=argo:default -n argo

kubectl create rolebinding namespace-admin --clusterrole=admin --serviceaccount=default:default -n argo
