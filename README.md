# Mehmat AKS - Microservice Deployment on Azure Kubernetes Service

This repository demonstrates how to deploy a microservice application using Docker images in Azure Kubernetes Service (AKS).

## Overview

This project contains:
- A sample Node.js microservice application
- Docker configuration for containerization
- Kubernetes manifests for AKS deployment
- Deployment scripts for automation

## Project Structure

```
.
├── server.js                 # Node.js microservice application
├── package.json              # Node.js dependencies
├── Dockerfile                # Docker image configuration
├── .dockerignore            # Docker ignore file
├── k8s/                     # Kubernetes manifests
│   ├── deployment.yaml      # Deployment configuration
│   ├── service.yaml         # Service configuration
│   └── configmap.yaml       # ConfigMap for environment variables
└── scripts/                 # Deployment scripts
    ├── build-and-push.sh    # Build and push to ACR
    └── deploy-to-aks.sh     # Deploy to AKS cluster
```

## Prerequisites

Before deploying, ensure you have:

1. **Azure CLI** installed and configured
   ```bash
   az login
   ```

2. **Docker** installed for building images

3. **kubectl** installed for Kubernetes management

4. **Azure Resources**:
   - Azure Container Registry (ACR)
   - Azure Kubernetes Service (AKS) cluster

## Setup Azure Resources

### 1. Create Resource Group

```bash
az group create --name mehmat-rg --location eastus
```

### 2. Create Azure Container Registry (ACR)

```bash
az acr create --resource-group mehmat-rg --name <YOUR_ACR_NAME> --sku Basic
```

### 3. Create AKS Cluster

```bash
az aks create \
  --resource-group mehmat-rg \
  --name mehmat-aks-cluster \
  --node-count 2 \
  --enable-addons monitoring \
  --generate-ssh-keys
```

### 4. Attach ACR to AKS

```bash
az aks update --resource-group mehmat-rg --name mehmat-aks-cluster --attach-acr <YOUR_ACR_NAME>
```

## Deployment Steps

### Option 1: Using Automated Scripts

#### Build and Push Docker Image

```bash
./scripts/build-and-push.sh <YOUR_ACR_NAME>
```

#### Deploy to AKS

```bash
./scripts/deploy-to-aks.sh <YOUR_ACR_NAME> mehmat-aks-cluster mehmat-rg
```

### Option 2: Manual Deployment

#### Step 1: Build Docker Image

```bash
docker build -t mehmat-microservice:latest .
```

#### Step 2: Tag and Push to ACR

```bash
# Login to ACR
az acr login --name <YOUR_ACR_NAME>

# Tag image
docker tag mehmat-microservice:latest <YOUR_ACR_NAME>.azurecr.io/mehmat-microservice:latest

# Push image
docker push <YOUR_ACR_NAME>.azurecr.io/mehmat-microservice:latest
```

#### Step 3: Connect to AKS

```bash
az aks get-credentials --resource-group mehmat-rg --name mehmat-aks-cluster
```

#### Step 4: Update Deployment Manifest

Edit `k8s/deployment.yaml` and replace `<YOUR_ACR_NAME>` with your actual ACR name.

#### Step 5: Deploy to Kubernetes

```bash
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

## Verify Deployment

### Check Deployment Status

```bash
kubectl get deployments
kubectl get pods
kubectl get services
```

### View Logs

```bash
kubectl logs -l app=mehmat-microservice
```

### Get External IP

```bash
kubectl get service mehmat-microservice
```

Wait for the `EXTERNAL-IP` to be assigned (may take a few minutes).

## Access the Microservice

Once the external IP is assigned, you can access the microservice:

```bash
# Health check
curl http://<EXTERNAL-IP>/health

# Root endpoint
curl http://<EXTERNAL-IP>/

# API endpoint
curl http://<EXTERNAL-IP>/api/message
```

## API Endpoints

- `GET /` - Welcome message and available endpoints
- `GET /health` - Health check endpoint
- `GET /api/message` - Sample API endpoint

## Scaling

### Scale the Deployment

```bash
kubectl scale deployment mehmat-microservice --replicas=5
```

### Enable Autoscaling

```bash
kubectl autoscale deployment mehmat-microservice --min=3 --max=10 --cpu-percent=80
```

## Monitoring

### View Pod Metrics

```bash
kubectl top pods
```

### View Service Events

```bash
kubectl describe service mehmat-microservice
kubectl describe deployment mehmat-microservice
```

## Update Deployment

After making changes to the code:

1. Build and push new image:
   ```bash
   ./scripts/build-and-push.sh <YOUR_ACR_NAME>
   ```

2. Restart deployment:
   ```bash
   kubectl rollout restart deployment/mehmat-microservice
   ```

## Cleanup

To delete all resources:

```bash
# Delete Kubernetes resources
kubectl delete -f k8s/

# Delete AKS cluster and related resources
az group delete --name mehmat-rg --yes --no-wait
```

## Troubleshooting

### Check Pod Logs

```bash
kubectl logs <pod-name>
```

### Describe Pod for Events

```bash
kubectl describe pod <pod-name>
```

### Check Image Pull Status

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
```

## Architecture

The deployment consists of:

- **Deployment**: Manages 3 replicas of the microservice
- **Service**: LoadBalancer type service for external access
- **ConfigMap**: Stores configuration data
- **Health Checks**: Liveness and readiness probes for container health
- **Resource Limits**: CPU and memory limits for optimal resource usage

## Technologies Used

- **Node.js & Express**: Microservice application
- **Docker**: Containerization
- **Azure Container Registry**: Container image storage
- **Azure Kubernetes Service**: Orchestration platform
- **Kubernetes**: Container orchestration

## License

MIT

## Contributing

Feel free to submit issues or pull requests for improvements.