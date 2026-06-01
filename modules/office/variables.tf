variable "office_name" {
  description = "Name of the office (houston, dallas, austin)"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for the office VNet"
  type        = string
}

variable "internal_subnet_cidr" {
  description = "CIDR block for the internal subnet"
  type        = string
}

variable "bastion_subnet_cidr" {
  description = "CIDR block for the Bastion subnet"
  type        = string
}

variable "location" {
  description = "Azure region for this office"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for this office"
  type        = string
}

variable "is_hub" {
  description = "Whether this office is the hub"
  type        = bool
  default     = false
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}