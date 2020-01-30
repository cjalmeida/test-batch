#!/bin/bash

set -e
. ./variables.sh
. ./password.sh

echo "loging to batch service"
az batch account login -g $RESOURCE_GROUP -n $BATCH_ACCOUNT

echo "create batch pool. We'll use a JSON file to specify advanced"
echo "container configurations"
envsubst '$POOL_ID $CLIENT_ID $CLIENT_SECRET $ACR_REGISTRY' < ./pool_configuration.json > /tmp/pool.json
az batch pool create --account-name $BATCH_ACCOUNT --json-file /tmp/pool.json

# enable pool autoscaling
# formula=`cat ./autoscale-formula.txt`
# az batch pool autoscale enable --pool-id $POOL_ID --auto-scale-formula "$formula"

# print current pool state
state=`az batch pool show --pool-id $POOL_ID --query allocationState`
echo "Pool '$POOL_ID' is currently in state: $state"