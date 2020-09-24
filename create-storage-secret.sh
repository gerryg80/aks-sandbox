#!/bin/bash

# This queries the aftermath of the terraform script to identify the storage account and keys
#    and create a corresponding kubernetes secret so the pods can access an azure files share

resource_group='aks-sandbox'

# there can be only one
storage_account=$(az storage account list --resource-group=$resource_group  | jq -r '.[0].name')

storage_key=$(az storage account keys list -n $storage_account | jq -r '.[0].value')

echo $storage_key

kubectl create secret generic pod-storage \
   --from-literal=azurestorageaccountname=$storage_account \
   --from-literal=azurestorageaccountkey=$storage_key

