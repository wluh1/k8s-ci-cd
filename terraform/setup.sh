cd terraform

echo ""
echo "Creating Cluster..."
terraform apply -auto-approve

echo ""
echo "Setting up Kubectl config..."
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw zone)

cd base

echo ""
echo "Applying nignx-ingress and chaos-mesh..."
terraform apply -auto-approve