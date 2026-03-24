variable "resource_id" {
  description = "The resource ID of the Load Balancer to monitor"
  type        = string
}

variable "resource_name" {
  description = "A friendly name for the resource (used in alert names)"
  type        = string
}

variable "resource_group_name" {
  description = "The resource group where the alerts will be created"
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
  description = "The alert profile to use (standard or critical)"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "critical"], var.profile)
    error_message = "Profile must be either 'standard' or 'critical'."
  }
}

variable "enabled" {
  description = "Whether the alerts are enabled"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "overrides" {
  description = "Override default thresholds for specific metrics"
  type = object({
    health_probe_status = optional(object({
      enabled            = optional(bool)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    data_path_availability = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    snat_connection_count = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    used_snat_ports = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
  })
  default = {}
}
