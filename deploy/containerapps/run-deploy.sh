#!/usr/bin/env bash
set -e

export RESOURCE_GROUP=rg-acadapr-1

# Could be used if you want to set the registry name without deploying the infra
# (just commenting out the infra deployment below, and update this value)
# export REGISTRY=crdevweutemp00.azurecr.io

# Deploy Container Apps Environment and its prerequisites
echo "Deploying Container Apps Environment and its prerequisites to $RESOURCE_GROUP..."
AZ_CAENV_DEPLOYMENT=$(az deployment group create \
                        --resource-group $RESOURCE_GROUP \
                        --template-file ./infra.bicep \
                        --parameters ./parameters.jsonc)

# echo "Retrieving Container Registry..."
REGISTRY=$(echo $AZ_CAENV_DEPLOYMENT | grep -oE -m 1 '/registries/([^/]+)' | tail -n +2 | cut -d'/' -f3).azurecr.io
echo "Container Registry: $REGISTRY"

# Login to Azure
echo "Logging in to Azure Container Registry..."
az acr login --name $REGISTRY

# Build and push images
echo "Building and pushing images..."
docker build -t $REGISTRY/summarizer/requests-api:latest ../../src/requests-api
docker build -t $REGISTRY/summarizer/requests-processor:latest ../../src/requests-processor
docker build -t $REGISTRY/summarizer/frontend:latest  ../../src/frontend
docker push $REGISTRY/summarizer/requests-api:latest
docker push $REGISTRY/summarizer/requests-processor:latest
docker push $REGISTRY/summarizer/frontend:latest

# Deploy Container Apps
echo "Deploying Container Apps..."
AZ_CAENV_DEPLOYMENT=$(az deployment group create \
                        --resource-group $RESOURCE_GROUP \
                        --template-file ./apps.bicep \
                        --parameters ./parameters.jsonc)
