locals {
  # Metric namespace for Azure SQL Managed Instance
  metric_namespace = "Microsoft.Sql/managedInstances"

  # Metric definitions
  metrics = {
    cpu = {
      name        = "avg_cpu_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Average CPU utilization percentage"
    }
    storage = {
      name        = "storage_space_used_mb"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Storage space used (MB)"
    }
    io_requests = {
      name        = "io_requests"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "IO requests count"
    }
    io_bytes = {
      name        = "io_bytes_read"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "IO bytes read"
    }
  }

  # Select the profile
  selected_profile = local.profiles[var.profile]

  # Resolved configuration with overrides
  resolved = {
    cpu = {
      enabled            = coalesce(try(var.overrides.cpu.enabled, null), local.selected_profile.cpu.enabled)
      warning_threshold  = coalesce(try(var.overrides.cpu.warning_threshold, null), local.selected_profile.cpu.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.cpu.critical_threshold, null), local.selected_profile.cpu.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.cpu.window_minutes, null), local.selected_profile.cpu.window_minutes)
    }
    storage = {
      enabled            = coalesce(try(var.overrides.storage.enabled, null), local.selected_profile.storage.enabled)
      warning_threshold  = coalesce(try(var.overrides.storage.warning_threshold, null), local.selected_profile.storage.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.storage.critical_threshold, null), local.selected_profile.storage.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.storage.window_minutes, null), local.selected_profile.storage.window_minutes)
    }
    io_requests = {
      enabled            = coalesce(try(var.overrides.io_requests.enabled, null), local.selected_profile.io_requests.enabled)
      warning_threshold  = coalesce(try(var.overrides.io_requests.warning_threshold, null), local.selected_profile.io_requests.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.io_requests.critical_threshold, null), local.selected_profile.io_requests.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.io_requests.window_minutes, null), local.selected_profile.io_requests.window_minutes)
    }
    io_bytes = {
      enabled            = coalesce(try(var.overrides.io_bytes.enabled, null), local.selected_profile.io_bytes.enabled)
      warning_threshold  = coalesce(try(var.overrides.io_bytes.warning_threshold, null), local.selected_profile.io_bytes.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.io_bytes.critical_threshold, null), local.selected_profile.io_bytes.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.io_bytes.window_minutes, null), local.selected_profile.io_bytes.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
