locals {
  # Metric namespace for Azure Cache for Redis
  metric_namespace = "Microsoft.Cache/redis"

  # Metric definitions
  metrics = {
    server_load = {
      name        = "serverLoad"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Server load percentage"
    }
    memory = {
      name        = "usedmemorypercentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Used memory percentage"
    }
    connected_clients = {
      name        = "connectedclients"
      aggregation = "Maximum"
      operator    = "GreaterThan"
      description = "Number of connected clients"
    }
    cache_miss_rate = {
      name        = "cachemissrate"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Cache miss rate percentage"
    }
    evicted_keys = {
      name        = "evictedkeys"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Number of evicted keys"
    }
  }

  # Select the profile
  selected_profile = local.profiles[var.profile]

  # Resolved configuration with overrides
  resolved = {
    server_load = {
      enabled            = coalesce(try(var.overrides.server_load.enabled, null), local.selected_profile.server_load.enabled)
      warning_threshold  = coalesce(try(var.overrides.server_load.warning_threshold, null), local.selected_profile.server_load.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.server_load.critical_threshold, null), local.selected_profile.server_load.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.server_load.window_minutes, null), local.selected_profile.server_load.window_minutes)
    }
    memory = {
      enabled            = coalesce(try(var.overrides.memory.enabled, null), local.selected_profile.memory.enabled)
      warning_threshold  = coalesce(try(var.overrides.memory.warning_threshold, null), local.selected_profile.memory.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.memory.critical_threshold, null), local.selected_profile.memory.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.memory.window_minutes, null), local.selected_profile.memory.window_minutes)
    }
    connected_clients = {
      enabled            = coalesce(try(var.overrides.connected_clients.enabled, null), local.selected_profile.connected_clients.enabled)
      warning_threshold  = coalesce(try(var.overrides.connected_clients.warning_threshold, null), local.selected_profile.connected_clients.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.connected_clients.critical_threshold, null), local.selected_profile.connected_clients.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.connected_clients.window_minutes, null), local.selected_profile.connected_clients.window_minutes)
    }
    cache_miss_rate = {
      enabled            = coalesce(try(var.overrides.cache_miss_rate.enabled, null), local.selected_profile.cache_miss_rate.enabled)
      warning_threshold  = coalesce(try(var.overrides.cache_miss_rate.warning_threshold, null), local.selected_profile.cache_miss_rate.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.cache_miss_rate.critical_threshold, null), local.selected_profile.cache_miss_rate.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.cache_miss_rate.window_minutes, null), local.selected_profile.cache_miss_rate.window_minutes)
    }
    evicted_keys = {
      enabled            = coalesce(try(var.overrides.evicted_keys.enabled, null), local.selected_profile.evicted_keys.enabled)
      warning_threshold  = coalesce(try(var.overrides.evicted_keys.warning_threshold, null), local.selected_profile.evicted_keys.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.evicted_keys.critical_threshold, null), local.selected_profile.evicted_keys.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.evicted_keys.window_minutes, null), local.selected_profile.evicted_keys.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
