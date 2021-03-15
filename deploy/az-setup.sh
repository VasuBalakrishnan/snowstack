#!/bin/bash

LOCATION=eastus2
RG_NAME=rg-snowstack
STORAGE_NAME=stosnowstack
DATAFACTORY_NAME=df-snowstack
APP_NAME=app-snowstack25692

# Resource Group
az group create --name $RG_NAME --location=$LOCATION --output table

# Storage Account
az storage account create -n $STORAGE_NAME -g $RG_NAME --kind StorageV2 -l $LOCATION -t Account

az storage container create -n root --account-name $STORAGE_NAME

az storage copy -s ../data/esg --account-name $STORAGE_NAME --destination-container root --recursive

# Data Factory
az datafactory factory create --location $LOCATION --name $DATAFACTORY_NAME --resource-group $RG_NAME

# App Service Plan
az appservice plan create --name $APP_NAME --resource-group $RG_NAME --sku FREE
