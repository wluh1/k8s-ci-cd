cd terraform

echo ""
echo "Creating Cluster..."
terraform init
terraform apply -auto-approve

echo ""
echo "Setting up Kubectl config..."
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw zone)


echo ""
echo "Applying nginx-ingress and chaos-mesh..."
cd base
terraform init
terraform apply -auto-approve
kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io validate-auth

cd ../../