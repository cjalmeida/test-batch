#!/bin/bash

. ./variables.sh
. ./password.sh
. ./image.sh

echo "create a job with a random id"
az batch job create \
    --id $JOB_ID \
    --account-name $BATCH_ACCOUNT \
    --pool-id $POOL_ID \
    --job-max-task-retry-count 1 \
    --job-max-wall-clock-time PT3H \
    --uses-task-dependencies

BLOB_URI="https://$STORAGE_ACCOUNT.blob.core.windows.net/$BLOB_NAME"

echo "create tasks"
tasks="task_generate_sample_data"
for task in tasks; do
    export task_id=task_$RANDOM
    export task full_uri
    envsubst < ./task_configuration.json > /tmp/task.json
    az batch task create --job-id $JOB_ID --json-file /tmp/task.json