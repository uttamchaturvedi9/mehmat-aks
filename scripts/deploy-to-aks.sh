#!/bin/bash

# Script to deploy microservice to AKS cluster

set -e

# Check if ACR name is provided
if [ -z "$1" ]; then
    echo "Usage: ./deploy-to-aks.sh <ACR_NAME> [AKS_CLUSTER_NAME] [RESOURCE_GROUP]"
    echo "Example: ./deploy-to-aks.sh myacrregistry myakscluster myresourcegroup"
    exit 1
fi

ACR_NAME=$1
AKS_CLUSTER_NAME=${2:-"mehmat-aks-cluster"}
RESOURCE_GROUP=${3:-"mehmat-rg"}
IMAGE_NAME="mehmat-microservice"

echo "=== Connecting to AKS cluster ==="
az aks get-credentials --resource-group ${RESOURCE_GROUP} --name ${AKS_CLUSTER_NAME} --overwrite-existing

echo ""
echo "=== Updating deployment manifest with ACR image ==="
sed "s/<YOUR_ACR_NAME>/${ACR_NAME}/g" k8s/deployment.yaml > /tmp/deployment.yaml

echo ""
echo "=== Applying Kubernetes manifests ==="
kubectl apply -f k8s/configmap.yaml
kubectl apply -f /tmp/deployment.yaml
kubectl apply -f k8s/service.yaml

echo ""
echo "=== Waiting for deployment to be ready ==="
kubectl rollout status deployment/mehmat-microservice

echo ""
echo "=== Getting service information ==="
kubectl get service mehmat-microservice
kubectl get pods -l app=mehmat-microservice

echo ""
echo "=== Deployment completed successfully ==="
echo "To get the external IP, run: kubectl get service mehmat-microservice"
