output "vnet_id" {
  description = "ID of the office VNet"
  value       = azurerm_virtual_network.office.id
}

output "vnet_name" {
  description = "Name of the office VNet"
  value       = azurerm_virtual_network.office.name
}

output "internal_subnet_id" {
  description = "ID of the internal subnet"
  value       = azurerm_subnet.internal.id
}

output "resource_group_name" {
  description = "Name of the office resource group"
  value       = azurerm_resource_group.office.name
}

output "vm_private_ip" {
  description = "Private IP address of the office VM"
  value       = azurerm_network_interface.office.private_ip_address
}

output "vm_name" {
  description = "Name of the office VM"
  value       = azurerm_linux_virtual_machine.office.name
}