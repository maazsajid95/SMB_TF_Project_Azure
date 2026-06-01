output "storage_account_name" {
  description = "Name of the shared storage account"
  value       = azurerm_storage_account.shared.name
}

output "storage_account_id" {
  description = "ID of the shared storage account"
  value       = azurerm_storage_account.shared.id
}

output "file_share_name" {
  description = "Name of the shared file share"
  value       = azurerm_storage_share.shared.name
}

output "storage_account_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.shared.primary_access_key
  sensitive   = true
}