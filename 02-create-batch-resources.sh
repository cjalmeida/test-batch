#!/bin/bash

. variables.sh

# set defaults
az configure --defaults location=$LOCATION

# create a resource group batch-test
az group create --location $LOCATION --name $RESOURCE_GROUP

# create storage account
az storage account create -g $RESOURCE_GROUP --name $STORAGE_ACCOUNT --kind StorageV2

# create a batch account
az batch account create -l $LOCATION -g $RESOURCE_GROUP \
    --name $BATCH_ACCOUNT \
    --storage-account $STORAGE_ACCOUNT

# create batch pool
az batch pool create --account-name $STORAGE_ACCOUNT --id $POOL_ID --image $IMAGE
