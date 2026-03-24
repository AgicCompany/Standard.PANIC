variable "name" {
  description = "Name of the metric alert rule"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the alert will be created"
  type        = string
}

variable "resource_id" {
  description = "Resource ID of the target resource to monitor"
  type        = string
}

variable "description" {
  description = "Description of the alert rule"
  type        = string
  default     = ""
}

variable "severity" {
  description = "Severity of the alert (0-4, where 0 is critical)"
  type        = number
  default     = 2

  validation {
    condition     = var.severity >= 0 && var.severity <= 4
    error_message = "Severity must be between 0 and 4."
  }
}

variable "enabled" {
  description = "Whether the alert rule is enabled"
  type        = bool
  default     = true
}

variable "auto_mitigate" {
  description = "Whether to auto-resolve the alert when condition clears"
  type        = bool
  default     = true
}

variable "frequency" {
  description = "How often the metric alert is evaluated (ISO 8601 duration)"
  type        = string
  default     = "PT1M"
}

variable "window_size" {
  description = "Period of time to evaluate the metric (ISO 8601 duration)"
  type        = string
  default     = "PT5M"
}

variable "metric_namespace" {
  description = "Azure metric namespace"
  type        = string
}

variable "metric_name" {
  description = "Name of the metric to monitor"
  type        = string
}

variable "aggregation" {
  description = "Aggregation type for the metric (Average, Count, Maximum, Minimum, Total)"
  type        = string
  default     = "Average"

  validation {
    condition     = contains(["Average", "Count", "Maximum", "Minimum", "Total"], var.aggregation)
    error_message = "Aggregation must be one of: Average, Count, Maximum, Minimum, Total."
  }
}

variable "operator" {
  description = "Comparison operator (Equals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual)"
  type        = string
  default     = "GreaterThan"

  validation {
    condition     = contains(["Equals", "GreaterThan", "GreaterThanOrEqual", "LessThan", "LessThanOrEqual", "NotEquals"], var.operator)
    error_message = "Operator must be one of: Equals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual, NotEquals."
  }
}

variable "threshold" {
  description = "Threshold value for the alert condition"
  type        = number
}

variable "dimensions" {
  description = "List of dimension filters for the metric"
  type = list(object({
    name     = string
    operator = string
    values   = list(string)
  }))
  default = []
}

variable "action_group_id" {
  description = "Resource ID of the action group for alert notifications"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the alert rule"
  type        = map(string)
  default     = {}
}
