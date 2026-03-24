locals {
  # Metric namespace for Azure MySQL Flexible Server
  metric_namespace = "Microsoft.DBforMySQL/flexibleServers"

  # Metric definitions
  metrics = {
    cpu = {
      name        = "cpu_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "CPU utilization percentage"
    }
    memory = {
      name        = "memory_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Memory utilization percentage"
    }
    storage = {
      name        = "storage_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Storage utilization percentage"
    }
    io = {
      name        = "io_consumption_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "IO consumption percentage"
    }
    connections = {
      name        = "active_connections"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Active database connections"
    }
    aborted_connections = {
      name        = "aborted_connections"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Aborted database connections"
    }
    replication_lag = {
      name        = "replication_lag"
      aggregation = "Maximum"
      operator    = "GreaterThan"
      description = "Replication lag in seconds"
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
    storage = {
      enabled            = coalesce(try(var.overrides.storage.enabled, null), local.selected_profile.storage.enabled)
      warning_threshold  = coalesce(try(var.overrides.storage.warning_threshold, null), local.selected_profile.storage.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.storage.critical_threshold, null), local.selected_profile.storage.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.storage.window_minutes, null), local.selected_profile.storage.window_minutes)
    }
    io = {
      enabled            = coalesce(try(var.overrides.io.enabled, null), local.selected_profile.io.enabled)
      warning_threshold  = coalesce(try(var.overrides.io.warning_threshold, null), local.selected_profile.io.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.io.critical_threshold, null), local.selected_profile.io.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.io.window_minutes, null), local.selected_profile.io.window_minutes)
    }
    connections = {
      enabled            = coalesce(try(var.overrides.connections.enabled, null), local.selected_profile.connections.enabled)
      warning_threshold  = coalesce(try(var.overrides.connections.warning_threshold, null), local.selected_profile.connections.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.connections.critical_threshold, null), local.selected_profile.connections.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.connections.window_minutes, null), local.selected_profile.connections.window_minutes)
    }
    aborted_connections = {
      enabled            = coalesce(try(var.overrides.aborted_connections.enabled, null), local.selected_profile.aborted_connections.enabled)
      warning_threshold  = coalesce(try(var.overrides.aborted_connections.warning_threshold, null), local.selected_profile.aborted_connections.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.aborted_connections.critical_threshold, null), local.selected_profile.aborted_connections.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.aborted_connections.window_minutes, null), local.selected_profile.aborted_connections.window_minutes)
    }
    replication_lag = {
      enabled            = coalesce(try(var.overrides.replication_lag.enabled, null), local.selected_profile.replication_lag.enabled)
      warning_threshold  = coalesce(try(var.overrides.replication_lag.warning_threshold, null), local.selected_profile.replication_lag.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.replication_lag.critical_threshold, null), local.selected_profile.replication_lag.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.replication_lag.window_minutes, null), local.selected_profile.replication_lag.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
