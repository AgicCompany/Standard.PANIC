variable "resource_id" {
  description = "Resource ID of the Storage Account to monitor"
  type        = string
}

variable "resource_name" {
  description = "Display name for the resource (used in alert names)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where alerts will be created"
  type        = string
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

variable "action_group_ids" {
  description = "Map of action group IDs for alert notifications"
  type = object({
    critical = string
    warning  = string
  })
}

variable "overrides" {
  description = "Optional overrides for specific metrics"
  type = object({
    availability = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    latency = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    throttling = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    used_capacity = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
  })
  default = {}
}

variable "enabled" {
  description = "Whether all alerts are enabled"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to alert rules"
  type        = map(string)
  default     = {}
}
