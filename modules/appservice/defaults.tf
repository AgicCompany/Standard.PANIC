locals {
  # Default alert settings
  defaults = {
    frequency_minutes = 1
    auto_mitigate     = true
    severity_warning  = 2
    severity_critical = 1
  }

  # Metric definitions for App Service
  # Note: CpuPercentage/MemoryPercentage are at App Service Plan level
  # For individual apps, use CpuTime and MemoryWorkingSet
  metrics = {
    cpu = {
      namespace   = "Microsoft.Web/sites"
      name        = "CpuTime"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "App Service CPU time in seconds"
    }
    memory = {
      namespace   = "Microsoft.Web/sites"
      name        = "AverageMemoryWorkingSet"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "App Service average memory working set in bytes"
    }
    http_5xx = {
      namespace   = "Microsoft.Web/sites"
      name        = "Http5xx"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "HTTP 5xx server error count"
    }
    response_time = {
      namespace   = "Microsoft.Web/sites"
      name        = "HttpResponseTime"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "HTTP response time in seconds"
    }
    health_check = {
      namespace   = "Microsoft.Web/sites"
      name        = "HealthCheckStatus"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Health check status (1 = healthy, 0 = unhealthy)"
    }
  }

  # Resolve final values: override -> profile -> defaults
  resolved = {
    cpu = {
      enabled            = coalesce(try(var.overrides.cpu.enabled, null), try(local.active_profile.cpu.enabled, false))
      warning_threshold  = coalesce(try(var.overrides.cpu.warning_threshold, null), local.active_profile.cpu.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.cpu.critical_threshold, null), local.active_profile.cpu.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.cpu.window_minutes, null), local.active_profile.cpu.window_minutes)
    }
    memory = {
      enabled            = coalesce(try(var.overrides.memory.enabled, null), try(local.active_profile.memory.enabled, false))
      warning_threshold  = coalesce(try(var.overrides.memory.warning_threshold, null), local.active_profile.memory.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.memory.critical_threshold, null), local.active_profile.memory.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.memory.window_minutes, null), local.active_profile.memory.window_minutes)
    }
    http_5xx = {
      enabled            = coalesce(try(var.overrides.http_5xx.enabled, null), true)
      warning_threshold  = coalesce(try(var.overrides.http_5xx.warning_threshold, null), local.active_profile.http_5xx.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.http_5xx.critical_threshold, null), local.active_profile.http_5xx.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.http_5xx.window_minutes, null), local.active_profile.http_5xx.window_minutes)
    }
    response_time = {
      enabled            = coalesce(try(var.overrides.response_time.enabled, null), true)
      warning_threshold  = coalesce(try(var.overrides.response_time.warning_threshold, null), local.active_profile.response_time.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.response_time.critical_threshold, null), local.active_profile.response_time.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.response_time.window_minutes, null), local.active_profile.response_time.window_minutes)
    }
    health_check = {
      enabled            = coalesce(try(var.overrides.health_check.enabled, null), true)
      critical_threshold = coalesce(try(var.overrides.health_check.critical_threshold, null), local.active_profile.health_check.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.health_check.window_minutes, null), local.active_profile.health_check.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by     = "terraform"
    module-version = "1.0.1"
  })
}
