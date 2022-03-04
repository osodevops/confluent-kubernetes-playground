After running 'az login', run:

`az ad sp create-for-rbac --skip-assignment`

{
  "appId": "e93e1daf-d796-41e7-92ca-dc1c7e8b1c9c",
  "displayName": "azure-cli-2022-03-02-10-28-01",
  "password": "TbXb.RdlCm1lGWpcs.JKLYQ-tQD6bROW2v",
  "tenant": "038722e1-fa3c-4727-a529-5269c8eed0ff"
}


`az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)`

`az aks browse --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)`