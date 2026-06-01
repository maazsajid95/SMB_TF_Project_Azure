variable "location" {
  description = "Azure region for shared services"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for shared services"
  type        = string
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
}

variable "houston_subnet_id" {
  description = "Internal subnet ID of Houston office"
  type        = string
}

variable "dallas_subnet_id" {
  description = "Internal subnet ID of Dallas office"
  type        = string
}

variable "austin_subnet_id" {
  description = "Internal subnet ID of Austin office"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace for diagnostics"
  type        = string
}