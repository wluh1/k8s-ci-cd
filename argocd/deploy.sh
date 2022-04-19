echo ""
echo "Setting up ArgoCD..."
cd terraform
terraform init
terraform apply -auto-approve
cd ..

# echo ""
# echo "Setting up argoCD CLI..."
# argocd login 35.241.195.23 --insecure --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --plaintext


echo ""
echo "Applying application..."
kubectl apply -f application.yaml

echo ""
echo "UI Password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo