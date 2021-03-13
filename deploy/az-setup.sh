#!/bin/bash

LOCATION=eastus2
RG_NAME=rg-snowstack
STORAGE_NAME=stosnowstack
DATAFACTORY_NAME=df-snowstack
APP_NAME=app-snowstack$RANDOM

# Resource Group
az group create --name $RG_NAME --location=$LOCATION --output table

# Storage Account
az storage account create -n $STORAGE_NAME -g $RG_NAME --kind StorageV2 -l $LOCATION -t Account

# Data Factory
az datafactory factory create --location $LOCATION --name $DATAFACTORY_NAME --resource-group $RG_NAME

# App Service Plan
az appservice plan create --name $APP_NAME --resource-group $RG_NAME --sku FREE

# Create Web App
az webapp create --name $APP_NAME --resource-group $RG_NAME --plan $APP_NAME