locals {
  # Metric namespace for Azure Key Vault
  metric_namespace = "Microsoft.KeyVault/vaults"

  # Metric definitions
  metrics = {
    availability = {
      name        = "Availability"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Vault requests availability percentage"
    }
    latency = {
      name        = "ServiceApiLatency"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Service API latency in milliseconds"
    }
    saturation = {
      name        = "SaturationShoebox"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Vault capacity saturation percentage"
    }
    api_hits = {
      name        = "ServiceApiHit"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Total service API hits"
    }
  }

  # Select the profile
  selected_profile = local.profiles[var.profile]

  # Resolved configuration with overrides
  resolved = {
    availability = {
      enabled            = coalesce(try(var.overrides.availability.enabled, null), local.selected_profile.availability.enabled)
      warning_threshold  = coalesce(try(var.overrides.availability.warning_threshold, null), local.selected_profile.availability.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.availability.critical_threshold, null), local.selected_profile.availability.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.availability.window_minutes, null), local.selected_profile.availability.window_minutes)
    }
    latency = {
      enabled            = coalesce(try(var.overrides.latency.enabled, null), local.selected_profile.latency.enabled)
      warning_threshold  = coalesce(try(var.overrides.latency.warning_threshold, null), local.selected_profile.latency.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.latency.critical_threshold, null), local.selected_profile.latency.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.latency.window_minutes, null), local.selected_profile.latency.window_minutes)
    }
    saturation = {
      enabled            = coalesce(try(var.overrides.saturation.enabled, null), local.selected_profile.saturation.enabled)
      warning_threshold  = coalesce(try(var.overrides.saturation.warning_threshold, null), local.selected_profile.saturation.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.saturation.critical_threshold, null), local.selected_profile.saturation.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.saturation.window_minutes, null), local.selected_profile.saturation.window_minutes)
    }
    api_hits = {
      enabled            = coalesce(try(var.overrides.api_hits.enabled, null), local.selected_profile.api_hits.enabled)
      warning_threshold  = coalesce(try(var.overrides.api_hits.warning_threshold, null), local.selected_profile.api_hits.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.api_hits.critical_threshold, null), local.selected_profile.api_hits.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.api_hits.window_minutes, null), local.selected_profile.api_hits.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
