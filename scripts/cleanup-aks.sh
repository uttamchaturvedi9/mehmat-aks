#!/bin/bash

# AKS Cluster Cleanup Script
# This script deletes the AKS cluster and all associated resources

set -e

# Configuration variables
RESOURCE_GROUP="mehmat-aks-rg"
CLUSTER_NAME="mehmat-aks-cluster"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}This will delete the AKS cluster and all associated resources.${NC}"
echo -e "${YELLOW}Resource group: ${RESOURCE_GROUP}${NC}"
echo -e "${YELLOW}Cluster name: ${CLUSTER_NAME}${NC}"
echo ""
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo -e "${RED}Cleanup cancelled.${NC}"
    exit 0
fi

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}Azure CLI is not installed.${NC}"
    exit 1
fi

# Check if logged in
if ! az account show &> /dev/null; then
    echo -e "${RED}Not logged in to Azure. Please run 'az login' first.${NC}"
    exit 1
fi

# Delete AKS cluster
echo -e "${YELLOW}Deleting AKS cluster: ${CLUSTER_NAME}...${NC}"
az aks delete \
    --resource-group ${RESOURCE_GROUP} \
    --name ${CLUSTER_NAME} \
    --yes \
    --no-wait

# Optional: Delete the entire resource group
read -p "Do you want to delete the entire resource group? (yes/no): " DELETE_RG

if [ "$DELETE_RG" == "yes" ]; then
    echo -e "${YELLOW}Deleting resource group: ${RESOURCE_GROUP}...${NC}"
    az group delete \
        --name ${RESOURCE_GROUP} \
        --yes \
        --no-wait
    echo -e "${GREEN}Resource group deletion initiated.${NC}"
else
    echo -e "${GREEN}AKS cluster deletion initiated.${NC}"
fi

echo -e "${GREEN}Cleanup process started. Resources will be deleted in the background.${NC}"
