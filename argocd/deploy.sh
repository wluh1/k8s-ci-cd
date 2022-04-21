echo ""
echo "Setting up ArgoCD..."
cd terraform
terraform init
terraform apply -auto-approve
cd ..

echo ""
echo "Applying application..."
kubectl apply -f application.yaml

echo ""
echo "UI Password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
