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
  description = "Name of the monitoring resource group"
  type        = string
  default     = "rg-monitoring-dev"
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "law-monitoring-dev"
}

variable "log_retention_days" {
  description = "Log retention period in days"
  type        = number
  default     = 30
}

variable "action_group_critical_name" {
  description = "Name of the critical severity action group"
  type        = string
  default     = "ag-dev-critical"
}

variable "action_group_warning_name" {
  description = "Name of the warning severity action group"
  type        = string
  default     = "ag-dev-warning"
}

variable "critical_email_receivers" {
  description = "List of email receivers for critical alerts"
  type = list(object({
    name  = string
    email = string
  }))
  default = []
}

variable "warning_email_receivers" {
  description = "List of email receivers for warning alerts"
  type = list(object({
    name  = string
    email = string
  }))
  default = []
}
