locals {
  # Default alert settings
  defaults = {
    frequency_minutes = 1
    auto_mitigate     = true
    severity_warning  = 2
    severity_critical = 1
  }

  # Metric definitions for PostgreSQL Flexible Server
  metrics = {
    cpu = {
      namespace   = "Microsoft.DBforPostgreSQL/flexibleServers"
      name        = "cpu_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "PostgreSQL CPU utilization percentage"
    }
    memory = {
      namespace   = "Microsoft.DBforPostgreSQL/flexibleServers"
      name        = "memory_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "PostgreSQL memory utilization percentage"
    }
    storage = {
      namespace   = "Microsoft.DBforPostgreSQL/flexibleServers"
      name        = "storage_percent"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "PostgreSQL storage utilization percentage"
    }
    connections = {
      namespace   = "Microsoft.DBforPostgreSQL/flexibleServers"
      name        = "active_connections"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "PostgreSQL active connections count"
    }
    failed_connections = {
      namespace   = "Microsoft.DBforPostgreSQL/flexibleServers"
      name        = "connections_failed"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "PostgreSQL failed connection attempts"
    }
    availability = {
      namespace   = "Microsoft.DBforPostgreSQL/flexibleServers"
      name        = "is_db_alive"
      aggregation = "Minimum"
      operator    = "LessThan"
      description = "PostgreSQL database availability (1 = alive, 0 = down)"
    }
    replication_lag = {
      namespace   = "Microsoft.DBforPostgreSQL/flexibleServers"
      name        = "physical_replication_delay_in_seconds"
      aggregation = "Maximum"
      operator    = "GreaterThan"
      description = "PostgreSQL replication lag in seconds (read replicas only)"
    }
  }

  # Resolve final values: override -> profile -> defaults
  resolved = {
    cpu = {
      enabled            = try(var.overrides.cpu.enabled, local.active_profile.cpu.enabled)
      warning_threshold  = try(var.overrides.cpu.warning_threshold, local.active_profile.cpu.warning_threshold)
      critical_threshold = try(var.overrides.cpu.critical_threshold, local.active_profile.cpu.critical_threshold)
      window_minutes     = try(var.overrides.cpu.window_minutes, local.active_profile.cpu.window_minutes)
    }
    memory = {
      enabled            = try(var.overrides.memory.enabled, local.active_profile.memory.enabled)
      warning_threshold  = try(var.overrides.memory.warning_threshold, local.active_profile.memory.warning_threshold)
      critical_threshold = try(var.overrides.memory.critical_threshold, local.active_profile.memory.critical_threshold)
      window_minutes     = try(var.overrides.memory.window_minutes, local.active_profile.memory.window_minutes)
    }
    storage = {
      enabled            = try(var.overrides.storage.enabled, local.active_profile.storage.enabled)
      warning_threshold  = try(var.overrides.storage.warning_threshold, local.active_profile.storage.warning_threshold)
      critical_threshold = try(var.overrides.storage.critical_threshold, local.active_profile.storage.critical_threshold)
      window_minutes     = try(var.overrides.storage.window_minutes, local.active_profile.storage.window_minutes)
    }
    connections = {
      enabled            = try(var.overrides.connections.enabled, local.active_profile.connections.enabled)
      warning_threshold  = try(var.overrides.connections.warning_threshold, local.active_profile.connections.warning_threshold)
      critical_threshold = try(var.overrides.connections.critical_threshold, local.active_profile.connections.critical_threshold)
      window_minutes     = try(var.overrides.connections.window_minutes, local.active_profile.connections.window_minutes)
    }
    failed_connections = {
      enabled            = try(var.overrides.failed_connections.enabled, local.active_profile.failed_connections.enabled)
      warning_threshold  = try(var.overrides.failed_connections.warning_threshold, local.active_profile.failed_connections.warning_threshold)
      critical_threshold = try(var.overrides.failed_connections.critical_threshold, local.active_profile.failed_connections.critical_threshold)
      window_minutes     = try(var.overrides.failed_connections.window_minutes, local.active_profile.failed_connections.window_minutes)
    }
    availability = {
      enabled            = try(var.overrides.availability.enabled, local.active_profile.availability.enabled)
      critical_threshold = try(var.overrides.availability.critical_threshold, local.active_profile.availability.critical_threshold)
      window_minutes     = try(var.overrides.availability.window_minutes, local.active_profile.availability.window_minutes)
    }
    replication_lag = {
      enabled            = try(var.overrides.replication_lag.enabled, local.active_profile.replication_lag.enabled)
      warning_threshold  = try(var.overrides.replication_lag.warning_threshold, local.active_profile.replication_lag.warning_threshold)
      critical_threshold = try(var.overrides.replication_lag.critical_threshold, local.active_profile.replication_lag.critical_threshold)
      window_minutes     = try(var.overrides.replication_lag.window_minutes, local.active_profile.replication_lag.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by     = "terraform"
    module-version = "1.0.0"
  })
}
