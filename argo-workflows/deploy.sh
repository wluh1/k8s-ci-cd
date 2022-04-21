echo ""
echo "Installing Argo-workflows..."
cd terraform
terraform init

echo ""
terraform apply -auto-approve
cd ..

echo ""
echo "Adding Roles for the Workflows Server"
kubectl apply -f ./config/github-secret.yaml
kubectl apply -f ./config/argo-server-roles.yaml
kubectl apply -f ./config/executor-roles.yaml

echo ""
echo "Adding The WorkflowTemplate and Event Bindings..."
kubectl apply -f ci-template.yaml
kubectl apply -f ./config/ci-binding.yaml

echo ""
echo "Setting up webhooks..."
kubectl apply -f ./config/github-roles.yaml
kubectl apply -f ./config/github-sa.yaml
kubectl apply -f ./config/github-binding.yaml

echo ""
echo "Token for the ArgoUI:"
argo auth token