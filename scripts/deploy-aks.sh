#!/bin/bash

# AKS Cluster Deployment Script using Azure CLI
# This script creates an AKS cluster with basic configuration

set -e

# Configuration variables
RESOURCE_GROUP="mehmat-aks-rg"
LOCATION="eastus"
CLUSTER_NAME="mehmat-aks-cluster"
NODE_COUNT=2
VM_SIZE="Standard_D2s_v3"
KUBERNETES_VERSION="1.27.7"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting AKS cluster deployment...${NC}"

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Azure CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if logged in
echo -e "${YELLOW}Checking Azure CLI authentication...${NC}"
if ! az account show &> /dev/null; then
    echo -e "${RED}Not logged in to Azure. Please run 'az login' first.${NC}"
    exit 1
fi

# Display current subscription
SUBSCRIPTION=$(az account show --query name -o tsv)
echo -e "${GREEN}Using subscription: ${SUBSCRIPTION}${NC}"

# Create resource group
echo -e "${YELLOW}Creating resource group: ${RESOURCE_GROUP}...${NC}"
az group create \
    --name ${RESOURCE_GROUP} \
    --location ${LOCATION} \
    --tags Environment=Development Project=Mehmat-AKS

# Create AKS cluster
echo -e "${YELLOW}Creating AKS cluster: ${CLUSTER_NAME}...${NC}"
echo -e "${YELLOW}This may take 10-15 minutes...${NC}"

az aks create \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTER_NAME} \
    --node-count ${NODE_COUNT} \
    --node-vm-size ${VM_SIZE} \
    --kubernetes-version ${KUBERNETES_VERSION} \
    --enable-managed-identity \
    --enable-addons monitoring \
    --enable-cluster-autoscaler \
    --min-count 1 \
    --max-count 5 \
    --network-plugin azure \
    --network-policy azure \
    --load-balancer-sku standard \
    --tags Environment=Development Project=Mehmat-AKS

# Get credentials for kubectl
echo -e "${YELLOW}Getting AKS credentials...${NC}"
az aks get-credentials \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTER_NAME} \
    --overwrite-existing

# Verify cluster connection
echo -e "${YELLOW}Verifying cluster connection...${NC}"
kubectl cluster-info
kubectl get nodes

echo -e "${GREEN}AKS cluster deployment completed successfully!${NC}"
echo -e "${GREEN}Cluster name: ${CLUSTER_NAME}${NC}"
echo -e "${GREEN}Resource group: ${RESOURCE_GROUP}${NC}"
echo -e "${GREEN}Location: ${LOCATION}${NC}"
echo ""
echo -e "${YELLOW}To interact with your cluster, use kubectl commands.${NC}"
echo -e "${YELLOW}Example: kubectl get nodes${NC}"
