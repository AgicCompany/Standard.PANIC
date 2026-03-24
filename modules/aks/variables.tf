variable "resource_id" {
  description = "The resource ID of the Azure Kubernetes Service cluster to monitor"
  type        = string
}

variable "resource_name" {
  description = "Display name for the alerts (used in alert naming)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the alerts will be created"
  type        = string
}

variable "action_group_ids" {
  description = "Map of action group IDs for alert notifications"
  type = object({
    critical = string
    warning  = string
  })
}

variable "profile" {
  description = "Alert profile to use (standard or critical)"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "critical"], var.profile)
    error_message = "Profile must be either 'standard' or 'critical'."
  }
}

variable "enabled" {
  description = "Enable or disable all alerts"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all alerts"
  type        = map(string)
  default     = {}
}

variable "overrides" {
  description = "Optional overrides for specific metrics"
  type = object({
    node_cpu = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    node_memory = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    node_disk = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    pod_ready = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    node_count = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
  })
  default = {}
}
