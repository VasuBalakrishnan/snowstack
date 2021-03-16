#!/bin/bash

LOCATION=eastus2
RG_NAME=rg-snowstack
STORAGE_NAME=stosnowstack
DATAFACTORY_NAME=df-snowstack
APP_NAME=app-snowstack25692
QUEUE_NAME=stosnowstackqueue
EVENT_SUB_NAME=stosnowstackeventsub

# Resource Group
az group create --name $RG_NAME --location=$LOCATION --output table

# Storage Account
az storage account create -n $STORAGE_NAME -g $RG_NAME --kind StorageV2 -l $LOCATION -t Account

az storage container create -n root --account-name $STORAGE_NAME

az storage copy -s ../data/esg --account-name $STORAGE_NAME --destination-container root --recursive

# Data Factory
az extension add --name datafactory
az datafactory factory create --location $LOCATION --name $DATAFACTORY_NAME --resource-group $RG_NAME

# App Service Plan
az appservice plan create --name $APP_NAME --resource-group $RG_NAME --sku FREE

# Event Grid

az provider register --namespace Microsoft.EventGrid
az provider show --namespace Microsoft.EventGrid --query "registrationState"

az storage queue create --name $QUEUE_NAME --account-name $STORAGE_NAME

export storage_id=$(az storage account show --name $STORAGE_NAME --resource-group $RG_NAME --query id --output tsv)
export queue_storage_id=$(az storage account show --name $STORAGE_NAME --resource-group $RG_NAME --query id --output tsv)
export queue_id="$queue_storage_id/queueservices/default/queues/$QUEUE_NAME"

az extension add --name eventgrid
az eventgrid event-subscription create --source-resource-id $storage_id \
    --name $EVENT_SUB_NAME --endpoint-type storagequeue --endpoint $queue_id