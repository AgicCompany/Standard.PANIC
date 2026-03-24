locals {
  # Metric namespace for Azure Functions
  metric_namespace = "Microsoft.Web/sites"

  # Metric definitions
  metrics = {
    http_5xx = {
      name        = "Http5xx"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "HTTP 5xx server errors"
    }
    http_4xx = {
      name        = "Http4xx"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "HTTP 4xx client errors"
    }
    response_time = {
      name        = "AverageResponseTime"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Average response time in seconds"
    }
    memory = {
      name        = "MemoryWorkingSet"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Memory working set in bytes"
    }
    execution_count = {
      name        = "FunctionExecutionCount"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Function execution count"
    }
  }

  # Select the profile
  selected_profile = local.profiles[var.profile]

  # Resolved configuration with overrides
  resolved = {
    http_5xx = {
      enabled            = coalesce(try(var.overrides.http_5xx.enabled, null), local.selected_profile.http_5xx.enabled)
      warning_threshold  = coalesce(try(var.overrides.http_5xx.warning_threshold, null), local.selected_profile.http_5xx.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.http_5xx.critical_threshold, null), local.selected_profile.http_5xx.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.http_5xx.window_minutes, null), local.selected_profile.http_5xx.window_minutes)
    }
    http_4xx = {
      enabled            = coalesce(try(var.overrides.http_4xx.enabled, null), local.selected_profile.http_4xx.enabled)
      warning_threshold  = coalesce(try(var.overrides.http_4xx.warning_threshold, null), local.selected_profile.http_4xx.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.http_4xx.critical_threshold, null), local.selected_profile.http_4xx.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.http_4xx.window_minutes, null), local.selected_profile.http_4xx.window_minutes)
    }
    response_time = {
      enabled            = coalesce(try(var.overrides.response_time.enabled, null), local.selected_profile.response_time.enabled)
      warning_threshold  = coalesce(try(var.overrides.response_time.warning_threshold, null), local.selected_profile.response_time.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.response_time.critical_threshold, null), local.selected_profile.response_time.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.response_time.window_minutes, null), local.selected_profile.response_time.window_minutes)
    }
    memory = {
      enabled            = coalesce(try(var.overrides.memory.enabled, null), local.selected_profile.memory.enabled)
      warning_threshold  = coalesce(try(var.overrides.memory.warning_threshold, null), local.selected_profile.memory.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.memory.critical_threshold, null), local.selected_profile.memory.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.memory.window_minutes, null), local.selected_profile.memory.window_minutes)
    }
    execution_count = {
      enabled            = coalesce(try(var.overrides.execution_count.enabled, null), local.selected_profile.execution_count.enabled)
      warning_threshold  = coalesce(try(var.overrides.execution_count.warning_threshold, null), local.selected_profile.execution_count.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.execution_count.critical_threshold, null), local.selected_profile.execution_count.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.execution_count.window_minutes, null), local.selected_profile.execution_count.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
