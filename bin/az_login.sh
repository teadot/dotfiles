#!/bin/bash

ENV_FILE=${HOME}/bin/.env

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Create file ${ENV_FILE} with tenant IDs!"
    exit 1
fi

source ${HOME}/bin/.env

echo "" > ${HOME}/.kube/config

check_env_var() {
    local var_name=$1
    local var_value=${!var_name}

    if [[ -z "$var_value" ]]; then
        echo "$var_name is not set."
        exit 1
    fi
}

login_fst() {
    check_env_var "FST_TENANT_ID"
    az login --tenant ${FST_TENANT_ID} --output none
    az account set --subscription "bdff5ebf-6ec5-48f1-b61c-65619922a818"
    az aks get-credentials --resource-group prd-eladb-rg-aks --name prd-eladb-aks-cluster --overwrite-existing

    kubelogin convert-kubeconfig -l azurecli
}

login_fpm() {
    check_env_var "FPM_TENANT_ID"
    az login --tenant ${FPM_TENANT_ID} --output none
    az account set --subscription "7a655048-2727-4a28-9e2c-cf6ad2bd6290" # sub-landingzones-fpm
    # az aks get-credentials --resource-group prd-eladb-rg-aks --name prd-eladb-aks-cluster --overwrite-existing
}

login_fgroup() {
    check_env_var "FGROUP_TENANT_ID"
    az login --tenant ${FGROUP_TENANT_ID} --output none
    az account set --subscription "az6"
    az aks get-credentials --resource-group rg_az6_aks_test --name aks_az6_rndhubtest_test --overwrite-existing
    az account set --subscription "az7"
    az aks get-credentials --resource-group rg_az7_aks_prod --name aks_az7_rndhubprod_prod --overwrite-existing
    az account set --subscription "az5"
    az aks get-credentials --resource-group rg_az5_aks_dev --name aks_az5_rndhub_dev --overwrite-existing

    kubelogin convert-kubeconfig -l azurecli
}

login_dev() {
    check_env_var "TC_FREUDENBERG_TENANT_ID"
    az login --tenant ${TC_FREUDENBERG_TENANT_ID} --output none
    az account set --subscription "TC_DEV"
}


if [[ "$1" == "FST" ]]; then
    ## FST
    login_fst
elif [[ "$1" == "FPM" ]]; then
    ## FPM
    login_fpm
elif [[ "$1" == "DEV" ]]; then
    ## VS Subscription
    login_dev
else
    ## FGROUP
    login_fgroup
fi

