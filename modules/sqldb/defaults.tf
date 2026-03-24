locals {
  # Metric namespace for Azure SQL Database
  metric_namespace = "Microsoft.Sql/servers/databases"

  # Metric definitions
  metrics = {
    cpu = {
      name        = "cpu_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "CPU utilization percentage"
    }
    dtu = {
      name        = "dtu_consumption_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "DTU consumption percentage"
    }
    storage = {
      name        = "storage_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Data space used percentage"
    }
    deadlocks = {
      name        = "deadlock"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Number of deadlocks"
    }
    connection_failed = {
      name        = "connection_failed"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Failed database connections"
    }
    sessions = {
      name        = "sessions_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Sessions percentage"
    }
    workers = {
      name        = "workers_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Workers percentage"
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
    dtu = {
      enabled            = coalesce(try(var.overrides.dtu.enabled, null), local.selected_profile.dtu.enabled)
      warning_threshold  = coalesce(try(var.overrides.dtu.warning_threshold, null), local.selected_profile.dtu.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.dtu.critical_threshold, null), local.selected_profile.dtu.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.dtu.window_minutes, null), local.selected_profile.dtu.window_minutes)
    }
    storage = {
      enabled            = coalesce(try(var.overrides.storage.enabled, null), local.selected_profile.storage.enabled)
      warning_threshold  = coalesce(try(var.overrides.storage.warning_threshold, null), local.selected_profile.storage.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.storage.critical_threshold, null), local.selected_profile.storage.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.storage.window_minutes, null), local.selected_profile.storage.window_minutes)
    }
    deadlocks = {
      enabled            = coalesce(try(var.overrides.deadlocks.enabled, null), local.selected_profile.deadlocks.enabled)
      warning_threshold  = coalesce(try(var.overrides.deadlocks.warning_threshold, null), local.selected_profile.deadlocks.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.deadlocks.critical_threshold, null), local.selected_profile.deadlocks.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.deadlocks.window_minutes, null), local.selected_profile.deadlocks.window_minutes)
    }
    connection_failed = {
      enabled            = coalesce(try(var.overrides.connection_failed.enabled, null), local.selected_profile.connection_failed.enabled)
      warning_threshold  = coalesce(try(var.overrides.connection_failed.warning_threshold, null), local.selected_profile.connection_failed.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.connection_failed.critical_threshold, null), local.selected_profile.connection_failed.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.connection_failed.window_minutes, null), local.selected_profile.connection_failed.window_minutes)
    }
    sessions = {
      enabled            = coalesce(try(var.overrides.sessions.enabled, null), local.selected_profile.sessions.enabled)
      warning_threshold  = coalesce(try(var.overrides.sessions.warning_threshold, null), local.selected_profile.sessions.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.sessions.critical_threshold, null), local.selected_profile.sessions.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.sessions.window_minutes, null), local.selected_profile.sessions.window_minutes)
    }
    workers = {
      enabled            = coalesce(try(var.overrides.workers.enabled, null), local.selected_profile.workers.enabled)
      warning_threshold  = coalesce(try(var.overrides.workers.warning_threshold, null), local.selected_profile.workers.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.workers.critical_threshold, null), local.selected_profile.workers.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.workers.window_minutes, null), local.selected_profile.workers.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
