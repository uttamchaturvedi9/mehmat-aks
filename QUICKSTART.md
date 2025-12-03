# AKS Cluster Deployment - Quick Start Guide

This guide provides a quick overview of deploying an AKS cluster using the infrastructure code in this repository.

## 🎯 What's Included

This repository provides two deployment methods:

1. **Terraform** - Infrastructure as Code (IaC) approach (Recommended for production)
2. **Azure CLI Scripts** - Quick deployment for testing and development

## ⚡ Quick Start (5 minutes)

### Prerequisites
- Azure account with active subscription
- Azure CLI installed
- kubectl installed (for cluster access)

### Fastest Path: Azure CLI Script

```bash
# 1. Login to Azure
az login

# 2. Run the deployment script
./scripts/deploy-aks.sh

# 3. Wait 10-15 minutes for cluster creation

# 4. Verify cluster
kubectl get nodes
```

That's it! Your AKS cluster is ready.

### Production Path: Terraform

```bash
# 1. Navigate to terraform directory
cd terraform

# 2. Copy and customize variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your preferences

# 3. Initialize Terraform
terraform init

# 4. Review planned changes
terraform plan

# 5. Deploy
terraform apply

# 6. Get cluster credentials
az aks get-credentials \
  --resource-group $(terraform output -raw resource_group_name) \
  --name $(terraform output -raw cluster_name)

# 7. Verify
kubectl get nodes
```

## 📊 Default Configuration

| Setting | Value |
|---------|-------|
| Location | East US |
| Node Count | 2 (auto-scales 1-5) |
| Node Size | Standard_D2s_v3 |
| Kubernetes Version | 1.27.7 |
| Network | Azure CNI |
| Monitoring | Enabled |

## 🎓 Next Steps

After deployment:

1. **Test the cluster**
   ```bash
   kubectl cluster-info
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

2. **Deploy a sample application**
   ```bash
   kubectl create deployment nginx --image=nginx
   kubectl expose deployment nginx --port=80 --type=LoadBalancer
   kubectl get service nginx
   ```

3. **Access monitoring**
   - Navigate to Azure Portal
   - Find your AKS cluster
   - Click on "Insights" to view monitoring data

## 🧹 Cleanup

When you're done, remove all resources to avoid charges:

**Using Script:**
```bash
./scripts/cleanup-aks.sh
```

**Using Terraform:**
```bash
cd terraform
terraform destroy
```

## 💡 Tips

- **Cost Optimization**: Start with 1-2 nodes and enable auto-scaling
- **Security**: The cluster uses system-assigned managed identity (no manual credential management)
- **Monitoring**: Azure Monitor is enabled by default for observability
- **Networking**: Uses Azure CNI for better integration with Azure services

## 📚 Full Documentation

See [README.md](README.md) for complete documentation including:
- Detailed prerequisites
- Advanced configuration options
- Architecture diagrams
- Troubleshooting guide

## ⚠️ Important Notes

1. Deployment takes approximately 10-15 minutes
2. Default configuration creates resources that incur Azure charges
3. Always clean up resources when done to avoid unnecessary costs
4. Keep your kubectl config secure (contains cluster credentials)

## 🆘 Need Help?

- Check [README.md](README.md) for detailed documentation
- Review Azure AKS documentation: https://docs.microsoft.com/azure/aks/
- Check Terraform AzureRM provider docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
