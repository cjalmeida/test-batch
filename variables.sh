# version of this demo run
export V=2

# Azure location to use
export LOCATION=eastus

# resource group
export RESOURCE_GROUP=ipprg$V

# storage account name and a blob container
export STORAGE_ACCOUNT=ipptestbatchstorage$V
export BLOB_NAME=ippblob$V

# batch account name
export BATCH_ACCOUNT=ipptestbatchaccount$V

# azure container registry name
export ACR_NAME=ippacr$V
export ACR_REGISTRY=${ACR_NAME}.azurecr.io

# batch pool id
export POOL_ID=ipptestbatchpool$V

# Docker batch app container image
export APP_IMAGE=$ACR_REGISTRY/sample_job

# service principal name
export SP_NAME=ipp-acr-sp$V

# job id
export JOB_ID=ipp_job_$RANDOM