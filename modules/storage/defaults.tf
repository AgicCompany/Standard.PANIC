locals {
  # Default alert settings
  defaults = {
    frequency_minutes = 1
    auto_mitigate     = true
    severity_warning  = 2
    severity_critical = 1
  }

  # Metric definitions for Storage Account
  metrics = {
    availability = {
      namespace   = "Microsoft.Storage/storageAccounts"
      name        = "Availability"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Storage account availability percentage"
    }
    latency = {
      namespace   = "Microsoft.Storage/storageAccounts"
      name        = "SuccessE2ELatency"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "End-to-end latency in milliseconds"
    }
    throttling = {
      namespace   = "Microsoft.Storage/storageAccounts"
      name        = "Transactions"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Number of throttled transactions"
      dimensions = [{
        name     = "ResponseType"
        operator = "Include"
        values   = ["ClientThrottlingError", "ServerBusyError"]
      }]
    }
    used_capacity = {
      namespace   = "Microsoft.Storage/storageAccounts"
      name        = "UsedCapacity"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Storage account used capacity"
    }
  }

  # Resolve final values: override -> profile -> defaults
  resolved = {
    availability = {
      enabled            = try(var.overrides.availability.enabled, true)
      warning_threshold  = try(var.overrides.availability.warning_threshold, local.active_profile.availability.warning_threshold)
      critical_threshold = try(var.overrides.availability.critical_threshold, local.active_profile.availability.critical_threshold)
      window_minutes     = try(var.overrides.availability.window_minutes, local.active_profile.availability.window_minutes)
    }
    latency = {
      enabled            = try(var.overrides.latency.enabled, true)
      warning_threshold  = try(var.overrides.latency.warning_threshold, local.active_profile.latency.warning_threshold)
      critical_threshold = try(var.overrides.latency.critical_threshold, local.active_profile.latency.critical_threshold)
      window_minutes     = try(var.overrides.latency.window_minutes, local.active_profile.latency.window_minutes)
    }
    throttling = {
      enabled            = try(var.overrides.throttling.enabled, true)
      warning_threshold  = try(var.overrides.throttling.warning_threshold, local.active_profile.throttling.warning_threshold)
      critical_threshold = try(var.overrides.throttling.critical_threshold, local.active_profile.throttling.critical_threshold)
      window_minutes     = try(var.overrides.throttling.window_minutes, local.active_profile.throttling.window_minutes)
    }
    used_capacity = {
      enabled            = try(var.overrides.used_capacity.enabled, true)
      warning_threshold  = try(var.overrides.used_capacity.warning_threshold, local.active_profile.used_capacity.warning_threshold)
      critical_threshold = try(var.overrides.used_capacity.critical_threshold, local.active_profile.used_capacity.critical_threshold)
      window_minutes     = try(var.overrides.used_capacity.window_minutes, local.active_profile.used_capacity.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by     = "terraform"
    module-version = "1.0.0"
  })
}
