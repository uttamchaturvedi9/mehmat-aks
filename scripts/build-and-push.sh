#!/bin/bash

# Script to build and push Docker image to Azure Container Registry (ACR)

set -e

# Check if ACR name is provided
if [ -z "$1" ]; then
    echo "Usage: ./build-and-push.sh <ACR_NAME>"
    echo "Example: ./build-and-push.sh myacrregistry"
    exit 1
fi

ACR_NAME=$1
IMAGE_NAME="mehmat-microservice"
IMAGE_TAG="latest"

echo "=== Building Docker image ==="
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

echo ""
echo "=== Tagging image for ACR ==="
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}

echo ""
echo "=== Logging in to ACR ==="
az acr login --name ${ACR_NAME}

echo ""
echo "=== Pushing image to ACR ==="
docker push ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}

echo ""
echo "=== Image pushed successfully ==="
echo "Image: ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}"
