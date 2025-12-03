# Mehmat AKS - Azure Kubernetes Service Deployment

This repository contains Infrastructure as Code (IaC) for deploying an Azure Kubernetes Service (AKS) cluster. It provides both Terraform configurations and Azure CLI scripts for flexible deployment options.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Deployment Options](#deployment-options)
  - [Option 1: Terraform Deployment](#option-1-terraform-deployment-recommended)
  - [Option 2: Azure CLI Deployment](#option-2-azure-cli-deployment)
- [Cluster Configuration](#cluster-configuration)
- [Post-Deployment](#post-deployment)
- [Cleanup](#cleanup)
- [Architecture](#architecture)

## 🎯 Overview

This project deploys a production-ready AKS cluster with the following features:

- **Managed Kubernetes**: Fully managed AKS cluster with auto-scaling
- **Virtual Network**: Custom VNet and subnet configuration
- **Monitoring**: Integrated Azure Monitor and Log Analytics
- **Security**: System-assigned managed identity
- **Scalability**: Auto-scaling node pools (1-5 nodes)
- **High Availability**: Azure CNI networking with Azure Network Policy

## 📦 Prerequisites

Before deploying the AKS cluster, ensure you have the following:

### Required Tools

1. **Azure CLI** (version 2.30.0 or later)
   ```bash
   # Install Azure CLI
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   
   # Verify installation
   az --version
   ```

2. **Terraform** (version 1.0 or later) - Required for Terraform deployment
   ```bash
   # Install Terraform
   wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform
   
   # Verify installation
   terraform version
   ```

3. **kubectl** - Kubernetes command-line tool
   ```bash
   # Install kubectl
   az aks install-cli
   
   # Verify installation
   kubectl version --client
   ```

### Azure Authentication

```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account set --subscription "your-subscription-id"

# Verify your account
az account show
```

## 🚀 Deployment Options

### Option 1: Terraform Deployment (Recommended)

Terraform provides a declarative approach to infrastructure management with state tracking.

#### Step 1: Configure Variables

Copy the example variables file and customize it:

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` to customize your deployment:

```hcl
resource_group_name = "my-aks-rg"
location            = "East US"
cluster_name        = "my-aks-cluster"
node_count          = 2
vm_size             = "Standard_D2s_v3"
```

#### Step 2: Initialize Terraform

```bash
terraform init
```

#### Step 3: Review the Plan

```bash
terraform plan
```

#### Step 4: Deploy the Cluster

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

#### Step 5: Get Cluster Credentials

```bash
# Get the resource group and cluster name from Terraform outputs
RESOURCE_GROUP=$(terraform output -raw resource_group_name)
CLUSTER_NAME=$(terraform output -raw cluster_name)

# Configure kubectl
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME
```

### Option 2: Azure CLI Deployment

For a quick deployment without Terraform, use the provided shell script.

#### Step 1: Review Script Configuration

Edit `scripts/deploy-aks.sh` to customize the variables:

```bash
RESOURCE_GROUP="mehmat-aks-rg"
LOCATION="eastus"
CLUSTER_NAME="mehmat-aks-cluster"
NODE_COUNT=2
VM_SIZE="Standard_D2s_v3"
```

#### Step 2: Run Deployment Script

```bash
./scripts/deploy-aks.sh
```

The script will:
- Create a resource group
- Deploy the AKS cluster with monitoring
- Configure kubectl automatically
- Verify the cluster is running

## ⚙️ Cluster Configuration

### Default Configuration

| Component | Value | Description |
|-----------|-------|-------------|
| Kubernetes Version | 1.27.7 | Can be updated in variables |
| Node Count | 2 | Initial number of nodes |
| VM Size | Standard_D2s_v3 | 2 vCPUs, 8 GB RAM |
| Auto-scaling | Enabled | Min: 1, Max: 5 nodes |
| Network Plugin | Azure CNI | Advanced networking |
| Network Policy | Azure | Network security policies |
| Monitoring | Enabled | Azure Monitor integration |

### Customization

You can customize the cluster by modifying:

**Terraform**: Edit `terraform/variables.tf` or `terraform/terraform.tfvars`

**Azure CLI**: Edit variables in `scripts/deploy-aks.sh`

### Supported VM Sizes

Common VM sizes for AKS nodes:

- `Standard_D2s_v3` - 2 vCPUs, 8 GB RAM (Development)
- `Standard_D4s_v3` - 4 vCPUs, 16 GB RAM (Production)
- `Standard_D8s_v3` - 8 vCPUs, 32 GB RAM (High Performance)

## ✅ Post-Deployment

### Verify Cluster

```bash
# Check cluster information
kubectl cluster-info

# List nodes
kubectl get nodes

# View cluster resources
kubectl get all --all-namespaces

# Check cluster health
kubectl get componentstatuses
```

### Access the Dashboard

```bash
# Start the Kubernetes proxy
kubectl proxy

# Access at: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

### Deploy a Test Application

```bash
# Create a test deployment
kubectl create deployment nginx --image=nginx

# Expose the deployment
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Get the external IP (may take a few minutes)
kubectl get service nginx --watch
```

## 🧹 Cleanup

### Using Terraform

```bash
cd terraform
terraform destroy
```

Type `yes` when prompted to confirm the deletion.

### Using Azure CLI Script

```bash
./scripts/cleanup-aks.sh
```

Follow the prompts to delete the cluster and optionally the resource group.

### Manual Cleanup

```bash
# Delete the cluster
az aks delete --resource-group mehmat-aks-rg --name mehmat-aks-cluster --yes

# Delete the resource group (removes all resources)
az group delete --name mehmat-aks-rg --yes
```

## 🏗️ Architecture

The deployment creates the following Azure resources:

```
┌─────────────────────────────────────────────────────────┐
│                    Resource Group                        │
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │           Virtual Network (10.0.0.0/16)        │    │
│  │                                                 │    │
│  │  ┌──────────────────────────────────────┐     │    │
│  │  │  Subnet (10.0.1.0/24)                │     │    │
│  │  │                                        │     │    │
│  │  │  ┌──────────────────────────────┐   │     │    │
│  │  │  │   AKS Cluster                │   │     │    │
│  │  │  │   - System Managed Identity  │   │     │    │
│  │  │  │   - Auto-scaling Node Pool   │   │     │    │
│  │  │  │   - Azure CNI Networking     │   │     │    │
│  │  │  └──────────────────────────────┘   │     │    │
│  │  └──────────────────────────────────────┘     │    │
│  └────────────────────────────────────────────────┘    │
│                                                          │
│  ┌────────────────────────────────────────────────┐    │
│  │       Log Analytics Workspace                   │    │
│  │       - Container Insights                      │    │
│  │       - 30-day retention                        │    │
│  └────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

### Key Components

1. **Resource Group**: Contains all AKS-related resources
2. **Virtual Network**: Provides network isolation with a dedicated subnet
3. **AKS Cluster**: Managed Kubernetes control plane and worker nodes
4. **Log Analytics Workspace**: Collects metrics and logs for monitoring
5. **System-Assigned Managed Identity**: Provides secure access to Azure resources

## 📝 Additional Resources

- [Azure Kubernetes Service Documentation](https://docs.microsoft.com/azure/aks/)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Reference](https://docs.microsoft.com/cli/azure/aks)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## 📄 License

This project is provided as-is for educational and development purposes.