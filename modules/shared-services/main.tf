# Storage Account for Azure Files
resource "azurerm_storage_account" "shared" {
  name                     = "${replace(var.project_name, "-", "")}shared"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  tags = {
    project = var.project_name
  }
}

# Azure File Share
resource "azurerm_storage_share" "shared" {
  name                 = "companyfiles"
  storage_account_name = azurerm_storage_account.shared.name
  quota                = 100
}

# Private Endpoint for Storage — Houston
resource "azurerm_private_endpoint" "storage_houston" {
  name                = "storage-pe-houston"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.houston_subnet_id

  private_service_connection {
    name                           = "storage-houston-connection"
    private_connection_resource_id = azurerm_storage_account.shared.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  tags = {
    project = var.project_name
  }
}

# Private Endpoint for Storage — Dallas
resource "azurerm_private_endpoint" "storage_dallas" {
  name                = "storage-pe-dallas"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.dallas_subnet_id

  private_service_connection {
    name                           = "storage-dallas-connection"
    private_connection_resource_id = azurerm_storage_account.shared.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  tags = {
    project = var.project_name
  }
}

# Private Endpoint for Storage — Austin
resource "azurerm_private_endpoint" "storage_austin" {
  name                = "storage-pe-austin"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.austin_subnet_id

  private_service_connection {
    name                           = "storage-austin-connection"
    private_connection_resource_id = azurerm_storage_account.shared.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  tags = {
    project = var.project_name
  }
}

# Diagnostic Settings — send storage logs to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "storage-diagnostics"
  target_resource_id         = "${azurerm_storage_account.shared.id}/fileServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}