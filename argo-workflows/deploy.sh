echo ""
echo "Installing Argo-workflows..."
cd terraform
terraform init
echo ""
terraform apply -auto-approve
cd ..
