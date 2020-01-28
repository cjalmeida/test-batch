#!/bin/bash

. variables.sh

# loging to batch service
az batch account login -g $RESOURCE_GROUP -n $BATCH_ACCOUNT

# create batch pool
az batch pool create --account-name $STORAGE_ACCOUNT --id $POOL_ID --image $IMAGE
