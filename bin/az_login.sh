az login
az account set --subscription "az5"
az aks get-credentials --resource-group rg_az5_aks_dev --name aks_az5_rndhub_dev --overwrite-existing
az account set --subscription "az6"
az aks get-credentials --resource-group rg_az6_aks_test --name aks_az6_rndhubtest_test --overwrite-existing
az account set --subscription "az7"
az aks get-credentials --resource-group rg_az7_aks_prod --name aks_az7_rndhubprod_prod --overwrite-existing
az account set --subscription "fti-data-science.svc-mgmt"
az aks get-credentials --resource-group rg_svc-mon_aks_prod --name aks_svc-mon_monitoring_prod --overwrite-existing
kubelogin convert-kubeconfig -l azurecli
