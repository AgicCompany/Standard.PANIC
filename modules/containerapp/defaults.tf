locals {
  # Metric namespace for Azure Container Apps
  metric_namespace = "Microsoft.App/containerApps"

  # Metric definitions
  metrics = {
    cpu = {
      name        = "UsageNanoCores"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "CPU usage in nanocores"
    }
    memory = {
      name        = "WorkingSetBytes"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Memory working set in bytes"
    }
    restarts = {
      name        = "RestartCount"
      aggregation = "Maximum"
      operator    = "GreaterThan"
      description = "Container restart count"
    }
    replicas = {
      name        = "Replicas"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Number of replicas"
    }
    requests = {
      name        = "Requests"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Total requests"
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
    memory = {
      enabled            = coalesce(try(var.overrides.memory.enabled, null), local.selected_profile.memory.enabled)
      warning_threshold  = coalesce(try(var.overrides.memory.warning_threshold, null), local.selected_profile.memory.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.memory.critical_threshold, null), local.selected_profile.memory.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.memory.window_minutes, null), local.selected_profile.memory.window_minutes)
    }
    restarts = {
      enabled            = coalesce(try(var.overrides.restarts.enabled, null), local.selected_profile.restarts.enabled)
      warning_threshold  = coalesce(try(var.overrides.restarts.warning_threshold, null), local.selected_profile.restarts.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.restarts.critical_threshold, null), local.selected_profile.restarts.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.restarts.window_minutes, null), local.selected_profile.restarts.window_minutes)
    }
    replicas = {
      enabled            = coalesce(try(var.overrides.replicas.enabled, null), local.selected_profile.replicas.enabled)
      warning_threshold  = coalesce(try(var.overrides.replicas.warning_threshold, null), local.selected_profile.replicas.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.replicas.critical_threshold, null), local.selected_profile.replicas.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.replicas.window_minutes, null), local.selected_profile.replicas.window_minutes)
    }
    requests = {
      enabled            = coalesce(try(var.overrides.requests.enabled, null), local.selected_profile.requests.enabled)
      warning_threshold  = coalesce(try(var.overrides.requests.warning_threshold, null), local.selected_profile.requests.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.requests.critical_threshold, null), local.selected_profile.requests.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.requests.window_minutes, null), local.selected_profile.requests.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
