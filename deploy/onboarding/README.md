# Automated onboarding to Azure Subscription 

The following commands allows to provision into Azure subscription required assets to accomodate a workshop, incliding :
* New users with a dedicated password
* A dedicated resource group for the workshop (contributor right added to the users)
* A new Azure group with the users as members

## Install Terraform CLI 

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

## Login to Azure CLI

* Use the Azure CLI to login to your Azure subscription.

```bash
az login
```

## Define configuration variables

* Define the environment variables inside a tfvars file. 
* Copy paste the `envs/sample.tfvars` and rename it to `envs/dev.tfvars`. 
* Update it with the appropriate values.

```terraform
user_group_name = "user-group-name"
domain_name = "<domain>.onmicrosoft.com"
users = [
  {
    name                    = "user0"
    resource_group_name     = "rg-<suffix>"
    resource_group_location = "westeurope"
  },
  {
    name                    = "user1"
    resource_group_name     =  "rg-<suffix>"
    resource_group_location = "westeurope"
  },
  {
    name                    = "user2"
    resource_group_name     = "rg-<suffix>"
    resource_group_location = "westeurope"
  },
]
```

## Validate the terraform configuration

```bash
cd deploy/admin
terraform init
```

```bash
terraform plan -var-file envs/sample.tfvars -var user_default_password=set_your_pwd_here -out plan.out
```

## Execute the terraform configuration

```bash
terraform apply plan.out
```