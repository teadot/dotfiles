#!/bin/bash

az aks get-credentials --resource-group rg_az5_aks_dev --name aks_az5_rndhub_dev --subscription az5 --overwrite-existing --file ~/.kube/config
az aks get-credentials --resource-group rg_az6_aks_test --name aks_az6_rndhubtest_test --subscription az6 --overwrite-existing --file ~/.kube/config
az aks get-credentials --resource-group rg_az7_aks_prod --name aks_az7_rndhubprod_prod --subscription az7 --overwrite-existing --file ~/.kube/config

