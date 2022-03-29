cd terraform

echo ""
echo "Setting up ArgoCD..."
terraform apply -auto-approve

# echo ""
# echo "Setting up argoCD CLI..."
# argocd login 35.241.195.23 --insecure --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo) --plaintext

cd ..

echo ""
echo "Applying application..."
kubectl apply -f application.yaml
