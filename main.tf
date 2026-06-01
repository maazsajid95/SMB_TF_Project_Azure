terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "mathpracs-tfstate-rg"
    storage_account_name = "mathpracstfstate"
    container_name       = "tfstate"
    key                  = "smb-infra.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id            = var.subscription_id
  skip_provider_registration = true
}

# Houston Office (Hub)
module "houston" {
  source               = "./modules/office"
  office_name          = "houston"
  vnet_cidr            = "10.0.0.0/16"
  internal_subnet_cidr = "10.0.1.0/24"
  bastion_subnet_cidr  = "10.0.2.0/24"
  location             = var.location
  resource_group_name  = "smb-houston-rg"
  is_hub               = true
  project_name         = var.project_name
}

# Dallas Office (Spoke 1)
module "dallas" {
  source               = "./modules/office"
  office_name          = "dallas"
  vnet_cidr            = "10.1.0.0/16"
  internal_subnet_cidr = "10.1.1.0/24"
  bastion_subnet_cidr  = "10.1.2.0/24"
  location             = var.location
  resource_group_name  = "smb-dallas-rg"
  is_hub               = false
  project_name         = var.project_name
}

# Austin Office (Spoke 2)
module "austin" {
  source               = "./modules/office"
  office_name          = "austin"
  vnet_cidr            = "10.2.0.0/16"
  internal_subnet_cidr = "10.2.1.0/24"
  bastion_subnet_cidr  = "10.2.2.0/24"
  location             = var.location
  resource_group_name  = "smb-austin-rg"
  is_hub               = false
  project_name         = var.project_name
}

# Hub Module — VNet Peering + Log Analytics + Key Vault
module "hub" {
  source = "./modules/hub"

  location             = var.location
  resource_group_name  = module.houston.resource_group_name
  project_name         = var.project_name

  houston_vnet_id      = module.houston.vnet_id
  dallas_vnet_id       = module.dallas.vnet_id
  austin_vnet_id       = module.austin.vnet_id

  houston_vnet_name    = module.houston.vnet_name
  dallas_vnet_name     = module.dallas.vnet_name
  austin_vnet_name     = module.austin.vnet_name

  houston_resource_group_name = module.houston.resource_group_name
  dallas_resource_group_name  = module.dallas.resource_group_name
  austin_resource_group_name  = module.austin.resource_group_name
}

# Shared Services — Azure Files + Private Endpoints + Diagnostics
module "shared_services" {
  source = "./modules/shared-services"

  location                   = var.location
  resource_group_name        = module.houston.resource_group_name
  project_name               = var.project_name
  houston_subnet_id          = module.houston.internal_subnet_id
  dallas_subnet_id           = module.dallas.internal_subnet_id
  austin_subnet_id           = module.austin.internal_subnet_id
  log_analytics_workspace_id = module.hub.log_analytics_workspace_id
}