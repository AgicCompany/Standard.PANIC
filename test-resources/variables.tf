variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the test resources resource group"
  type        = string
  default     = "rg-monitoring-test"
}

variable "storage_account_prefix" {
  description = "Prefix for the test storage account name"
  type        = string
  default     = "stdevtest"
}
