cd terraform

echo ""
echo "Creating Cluster..."
terraform apply -auto-approve

echo ""
echo "Setting up Kubectl config..."
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw zone)


echo ""
echo "Applying nignx-ingress and chaos-mesh..."
cd base
terraform apply -auto-approve

cd ../../