# Check Point Terraform deployment modules for Azure CN

This project was developed to allow Terraform deployments for Check Point CloudGuard IaaS solutions on Azure.


These modules use Terraform's [Azurerm provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) in order to create and provision resources on Azure.


 ## Prerequisites

1. [Download Terraform](https://www.terraform.io/downloads.html) and follow the instructions according to your OS.
2. Get started with Terraform Azurerm provider - refer to [Terraform Azurerm provider best practices](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs).

## For Azure China Deployment Using Terraform
Note: All the steps as below are only for Azure China  
1. Set the Azure cloud to AzureChinaCloud
Before starting, set the Azure cloud environment to AzureChinaCloud in local machine:
```
az cloud set --name AzureChinaCloud
```

2. Modify the variable of Azure Cloud environment in terraform.tfvars
```
environment = "china" # "public" is for Azure global, "china" is for Azure China
```
3. Add environment AzureChinaCloud in cme  of management server(This is only for Azure China)  
Updated auto-provisioning commands to include the AzureChinaCloud environment:
```
autoprov_cfg set controller Azure -cn <NAME> --environment AzureChinaCloud
```
4. Register providers for Azure China
Registered the required providers for Azure China with the following commands:
```
az provider register --namespace Microsoft.Network --consent-to-permissions --verbose
az provider register --namespace Microsoft.Storage --consent-to-permissions --verbose
az provider register --namespace Microsoft.Compute --consent-to-permissions --verbose
az provider register --namespace Microsoft.insights --consent-to-permissions --verbose
```