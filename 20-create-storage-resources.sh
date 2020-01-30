#!/bin/bash

set -e
. ./variables.sh
. ./password.sh

echo "create blob container"
az storage container create --account-name $STORAGE_ACCOUNT --name $BLOB_NAME

echo "assign SP as blob owner"
subscription=`az account show --query id --output tsv`
scope="/subscriptions/$subscription/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT/blobServices/default/containers/$BLOB_NAME"
az role assignment create \
    --role "Storage Blob Data Owner" \
    --assignee $CLIENT_ID \
    --scope $scope