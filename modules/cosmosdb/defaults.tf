locals {
  # Metric namespace for Azure Cosmos DB
  metric_namespace = "Microsoft.DocumentDB/databaseAccounts"

  # Metric definitions
  metrics = {
    ru_consumption = {
      name        = "NormalizedRUConsumption"
      aggregation = "Maximum"
      operator    = "GreaterThan"
      description = "Normalized RU consumption percentage"
    }
    availability = {
      name        = "ServiceAvailability"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Service availability percentage"
    }
    server_latency = {
      name        = "ServerSideLatency"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Server-side latency in milliseconds"
    }
    throttled_requests = {
      name        = "TotalRequests"
      aggregation = "Count"
      operator    = "GreaterThan"
      description = "Throttled requests (429 status)"
    }
    total_requests = {
      name        = "TotalRequests"
      aggregation = "Count"
      operator    = "GreaterThan"
      description = "Total requests"
    }
  }

  # Select the profile
  selected_profile = local.profiles[var.profile]

  # Resolved configuration with overrides
  resolved = {
    ru_consumption = {
      enabled            = coalesce(try(var.overrides.ru_consumption.enabled, null), local.selected_profile.ru_consumption.enabled)
      warning_threshold  = coalesce(try(var.overrides.ru_consumption.warning_threshold, null), local.selected_profile.ru_consumption.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.ru_consumption.critical_threshold, null), local.selected_profile.ru_consumption.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.ru_consumption.window_minutes, null), local.selected_profile.ru_consumption.window_minutes)
    }
    availability = {
      enabled            = coalesce(try(var.overrides.availability.enabled, null), local.selected_profile.availability.enabled)
      warning_threshold  = coalesce(try(var.overrides.availability.warning_threshold, null), local.selected_profile.availability.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.availability.critical_threshold, null), local.selected_profile.availability.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.availability.window_minutes, null), local.selected_profile.availability.window_minutes)
    }
    server_latency = {
      enabled            = coalesce(try(var.overrides.server_latency.enabled, null), local.selected_profile.server_latency.enabled)
      warning_threshold  = coalesce(try(var.overrides.server_latency.warning_threshold, null), local.selected_profile.server_latency.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.server_latency.critical_threshold, null), local.selected_profile.server_latency.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.server_latency.window_minutes, null), local.selected_profile.server_latency.window_minutes)
    }
    throttled_requests = {
      enabled            = coalesce(try(var.overrides.throttled_requests.enabled, null), local.selected_profile.throttled_requests.enabled)
      warning_threshold  = coalesce(try(var.overrides.throttled_requests.warning_threshold, null), local.selected_profile.throttled_requests.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.throttled_requests.critical_threshold, null), local.selected_profile.throttled_requests.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.throttled_requests.window_minutes, null), local.selected_profile.throttled_requests.window_minutes)
    }
    total_requests = {
      enabled            = coalesce(try(var.overrides.total_requests.enabled, null), local.selected_profile.total_requests.enabled)
      warning_threshold  = coalesce(try(var.overrides.total_requests.warning_threshold, null), local.selected_profile.total_requests.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.total_requests.critical_threshold, null), local.selected_profile.total_requests.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.total_requests.window_minutes, null), local.selected_profile.total_requests.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
