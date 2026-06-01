# Resource Group
resource "azurerm_resource_group" "office" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project = var.project_name
    office  = var.office_name
    role    = var.is_hub ? "hub" : "spoke"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "office" {
  name                = "${var.office_name}-vnet"
  location            = azurerm_resource_group.office.location
  resource_group_name = azurerm_resource_group.office.name
  address_space       = [var.vnet_cidr]

  tags = {
    project = var.project_name
    office  = var.office_name
  }
}

# Internal Subnet
resource "azurerm_subnet" "internal" {
  name                 = "${var.office_name}-internal-subnet"
  resource_group_name  = azurerm_resource_group.office.name
  virtual_network_name = azurerm_virtual_network.office.name
  address_prefixes     = [var.internal_subnet_cidr]
}

# Bastion Subnet (name must be AzureBastionSubnet)
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.office.name
  virtual_network_name = azurerm_virtual_network.office.name
  address_prefixes     = [var.bastion_subnet_cidr]
}

# Network Security Group
resource "azurerm_network_security_group" "office" {
  name                = "${var.office_name}-nsg"
  location            = azurerm_resource_group.office.location
  resource_group_name = azurerm_resource_group.office.name

  security_rule {
    name                       = "allow-internal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/8"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny-internet-inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = {
    project = var.project_name
    office  = var.office_name
  }
}

# Associate NSG with internal subnet
resource "azurerm_subnet_network_security_group_association" "office" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.office.id
}

# Public IP for Bastion (only for hub)
resource "azurerm_public_ip" "bastion" {
  count               = var.is_hub ? 1 : 0
  name                = "${var.office_name}-bastion-pip"
  location            = azurerm_resource_group.office.location
  resource_group_name = azurerm_resource_group.office.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    project = var.project_name
    office  = var.office_name
  }
}

# Bastion Host (only for hub)
resource "azurerm_bastion_host" "office" {
  count               = var.is_hub ? 1 : 0
  name                = "${var.office_name}-bastion"
  location            = azurerm_resource_group.office.location
  resource_group_name = azurerm_resource_group.office.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }

  tags = {
    project = var.project_name
    office  = var.office_name
  }
}

# Network Interface for VM
resource "azurerm_network_interface" "office" {
  name                = "${var.office_name}-nic"
  location            = azurerm_resource_group.office.location
  resource_group_name = azurerm_resource_group.office.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    project = var.project_name
    office  = var.office_name
  }
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "office" {
  name                            = "${var.office_name}-vm"
  location                        = azurerm_resource_group.office.location
  resource_group_name             = azurerm_resource_group.office.name
  size                            = "Standard_B2s"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.office.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    project = var.project_name
    office  = var.office_name
  }
}