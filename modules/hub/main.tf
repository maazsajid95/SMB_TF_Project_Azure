# VNet Peering — Houston to Dallas
resource "azurerm_virtual_network_peering" "houston_to_dallas" {
  name                      = "houston-to-dallas"
  resource_group_name       = var.houston_resource_group_name
  virtual_network_name      = var.houston_vnet_name
  remote_virtual_network_id = var.dallas_vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

# VNet Peering — Dallas to Houston
resource "azurerm_virtual_network_peering" "dallas_to_houston" {
  name                      = "dallas-to-houston"
  resource_group_name       = var.dallas_resource_group_name
  virtual_network_name      = var.dallas_vnet_name
  remote_virtual_network_id = var.houston_vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

# VNet Peering — Houston to Austin
resource "azurerm_virtual_network_peering" "houston_to_austin" {
  name                      = "houston-to-austin"
  resource_group_name       = var.houston_resource_group_name
  virtual_network_name      = var.houston_vnet_name
  remote_virtual_network_id = var.austin_vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

# VNet Peering — Austin to Houston
resource "azurerm_virtual_network_peering" "austin_to_houston" {
  name                      = "austin-to-houston"
  resource_group_name       = var.austin_resource_group_name
  virtual_network_name      = var.austin_vnet_name
  remote_virtual_network_id = var.houston_vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

# Log Analytics Workspace (centralized logging for all offices)
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    project = var.project_name
  }
}

# Key Vault (centralized secrets management)
resource "azurerm_key_vault" "main" {
  name                = "${var.project_name}-kv"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = {
    project = var.project_name
  }
}

# Get current Azure client config (needed for Key Vault tenant ID)
data "azurerm_client_config" "current" {}