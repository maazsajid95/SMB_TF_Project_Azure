variable "location" {
  description = "Azure region for hub resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where hub shared services live"
  type        = string
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "houston_vnet_id" {
  description = "VNet ID of Houston office"
  type        = string
}

variable "dallas_vnet_id" {
  description = "VNet ID of Dallas office"
  type        = string
}

variable "austin_vnet_id" {
  description = "VNet ID of Austin office"
  type        = string
}

variable "houston_vnet_name" {
  description = "VNet name of Houston office"
  type        = string
}

variable "dallas_vnet_name" {
  description = "VNet name of Dallas office"
  type        = string
}

variable "austin_vnet_name" {
  description = "VNet name of Austin office"
  type        = string
}

variable "houston_resource_group_name" {
  description = "Resource group name of Houston office"
  type        = string
}

variable "dallas_resource_group_name" {
  description = "Resource group name of Dallas office"
  type        = string
}

variable "austin_resource_group_name" {
  description = "Resource group name of Austin office"
  type        = string
}