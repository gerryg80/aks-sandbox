## Terraform for creating AKS Cluster with Windows Node Pool

This project creates a simple AKS cluster using the Azure CNI so the cluster will support a windows node pool.

The Azure CNI requires creating a virtual network and subnet along with the cluster.

This includes a proof of concept demonstrating a "shim" container that launches an app from a Azure Files Share using only the base Windows Aspnet Container

Note the scripts in here make a lot of assumptions about installed tools such as "jq" the Azure CLI (az) Powershell etc. This is not a bullet proof script or even a recipe but more of a rough documentation of the steps so I can repeat it myself.  Use with caution

## Steps

1. Use Terraform to create cluster
1. get credentials on the new cluster so you can use kubectl going forward
1. execute the "create-storage-secret.sh" from this project to create the secret that enables kubernetes to access the storage account created in terraform
1. Build / Publish the companion "Freds" project
1. Use the Copy-ToAzure.ps1 powershell script in Freds/Freds to initialize the share on the storage account
1. Come back to this project and apply the "deploy-fred.yaml" file to install the shim

You should be able to access the "Freds" API at this point using curl.
1. Use "kubectl get svc" to locate the Freds service public IP address
2. execute this command to add a fred
````shell
curl -X POST  http://<ip-address>/api/freds/ -d '{"id":0,"surname":"Durst"}' -H "Content-type: application/json"
````
3. execute this command to see all the freds that have been added
````shell
curl http://<ip-address>/api/freds/
````
4. PUT and DELETE have the expected outcomes as well.

## Bonus

1. Change the Freds API in some way (i.e. add a Chads Controller) and rebuild
2. Use the Copy-DllToAzure.ps1 to copy the resulting DLL to the storage account
3. Observe that the existing pods automatically present the new controller for use.

