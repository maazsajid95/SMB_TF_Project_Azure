variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Primary Azure region"
  type        = string
  default     = "East US"
}

variable "project_name" {
  description = "Project name used for naming and tagging resources"
  type        = string
  default     = "smb-infra"
}