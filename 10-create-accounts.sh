#!/bin/bash

set -e

. ./variables.sh

# login first
# az login

echo "set default location"
az configure --defaults location=$LOCATION

echo "create a resource group"
az group create --location $LOCATION --name $RESOURCE_GROUP

echo "create storage account"
az storage account create -g $RESOURCE_GROUP --name $STORAGE_ACCOUNT --kind StorageV2

echo "create a batch account"
az batch account create -l $LOCATION -g $RESOURCE_GROUP \
    --name $BATCH_ACCOUNT \
    --storage-account $STORAGE_ACCOUNT

echo "create a container registry account"
az acr create -g $RESOURCE_GROUP \
    --name $ACR_NAME \
    --sku Basic

echo "create AD service principal and grant access to ACR"
export acr_id=`az acr show -n $ACR_NAME --query id --output tsv`
CLIENT_SECRET=`az ad sp create-for-rbac --name http://$SP_NAME \
    --scopes $acr_id \
    --role acrpull \
    --query password \
    --output tsv`
TENANT_ID=`az ad sp show --id http://$SP_NAME --query appOwnerTenantId --output tsv`
CLIENT_ID=`az ad sp show --id http://$SP_NAME --query appId --output tsv`
SUBSCRIPTION_ID=`az account show --query id --output tsv`

echo "export TENANT_ID=$TENANT_ID" > ./password.sh
echo "export CLIENT_ID=$CLIENT_ID" >> ./password.sh
echo "export CLIENT_SECRET=$CLIENT_SECRET" >> ./password.sh
echo "export SUBSCRIPTION_ID=$SUBSCRIPTION_ID" >> ./password.sh


echo "Exported service principal password to ./password.sh. Note this password \
cannot be extracted, so make sure to save it somewhere safe."