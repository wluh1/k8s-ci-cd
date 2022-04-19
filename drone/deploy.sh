echo ""
echo "Installing Drone..."
cd terraform

terraform init
terraform apply -auto-approve