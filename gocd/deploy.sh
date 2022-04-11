echo ""
echo "Installing GoCD..."
cd terraform
terraform init

echo ""
terraform apply -auto-approve
cd ..