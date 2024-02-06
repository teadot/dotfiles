#!/bin/bash

ENV_FILE=${HOME}/bin/.env

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Create file ~/bin/.env with tenant IDs!"
    exit 1
fi

source ~/bin/.env

echo "" > .kube/config

if [[ "$1" == "FST" ]]; then
    ## FST
    az login --tenant ${FST_TENANT_ID} --output none
    az account set --subscription "bdff5ebf-6ec5-48f1-b61c-65619922a818"
    az aks get-credentials --resource-group prd-eladb-rg-aks --name prd-eladb-aks-cluster --overwrite-existing
else
    ## FGROUP
    az login --tenant ${FGROUP_TENANT_ID} --output none
    az account set --subscription "az6"
    az aks get-credentials --resource-group rg_az6_aks_test --name aks_az6_rndhubtest_test --overwrite-existing
    az account set --subscription "az7"
    az aks get-credentials --resource-group rg_az7_aks_prod --name aks_az7_rndhubprod_prod --overwrite-existing
    az account set --subscription "fti-data-science.svc-mgmt"
    az aks get-credentials --resource-group rg_svc-mon_aks_prod --name aks_svc-mon_monitoring_prod --overwrite-existing
    az account set --subscription "az5"
    az aks get-credentials --resource-group rg_az5_aks_dev --name aks_az5_rndhub_dev --overwrite-existing
fi

kubelogin convert-kubeconfig -l azurecli
