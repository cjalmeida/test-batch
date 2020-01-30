#!/bin/bash

set -e

. ./variables.sh

# login to ACR, this does `docker login`
az acr login --name $ACR_NAME

# build container
cd sample_job
docker build -t $APP_IMAGE:v$V .
cd ..

# get container ID and retag
IMAGE_ID=`docker image ls -q $APP_IMAGE:v$V`
APP_IMAGE_TAG=$APP_IMAGE:$IMAGE_ID
docker image tag "$APP_IMAGE:v$V" $APP_IMAGE_TAG

# push to registry
docker push $APP_IMAGE_TAG

echo "export APP_IMAGE_TAG=$APP_IMAGE_TAG" > ./image.sh