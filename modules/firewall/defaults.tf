locals {
  metric_namespace = "Microsoft.Network/azureFirewalls"

  metrics = {
    health_state = {
      name        = "FirewallHealth"
      aggregation = "Average"
      description = "Azure Firewall health state percentage"
    }
    throughput = {
      name        = "Throughput"
      aggregation = "Average"
      description = "Firewall throughput in bits per second"
    }
    snat_port_utilization = {
      name        = "SNATPortUtilization"
      aggregation = "Average"
      description = "SNAT port utilization percentage"
    }
    latency = {
      name        = "FirewallLatencyProbe"
      aggregation = "Average"
      description = "Firewall latency probe in milliseconds"
    }
  }

  # Resolve final values: override -> profile -> defaults
  selected_profile = local.profiles[var.profile]

  resolved = {
    health_state = {
      enabled            = coalesce(try(var.overrides.health_state.enabled, null), local.selected_profile.health_state.enabled)
      warning_threshold  = coalesce(try(var.overrides.health_state.warning_threshold, null), local.selected_profile.health_state.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.health_state.critical_threshold, null), local.selected_profile.health_state.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.health_state.window_minutes, null), local.selected_profile.health_state.window_minutes)
    }
    throughput = {
      enabled            = coalesce(try(var.overrides.throughput.enabled, null), local.selected_profile.throughput.enabled)
      warning_threshold  = coalesce(try(var.overrides.throughput.warning_threshold, null), local.selected_profile.throughput.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.throughput.critical_threshold, null), local.selected_profile.throughput.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.throughput.window_minutes, null), local.selected_profile.throughput.window_minutes)
    }
    snat_port_utilization = {
      enabled            = coalesce(try(var.overrides.snat_port_utilization.enabled, null), local.selected_profile.snat_port_utilization.enabled)
      warning_threshold  = coalesce(try(var.overrides.snat_port_utilization.warning_threshold, null), local.selected_profile.snat_port_utilization.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.snat_port_utilization.critical_threshold, null), local.selected_profile.snat_port_utilization.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.snat_port_utilization.window_minutes, null), local.selected_profile.snat_port_utilization.window_minutes)
    }
    latency = {
      enabled            = coalesce(try(var.overrides.latency.enabled, null), local.selected_profile.latency.enabled)
      warning_threshold  = coalesce(try(var.overrides.latency.warning_threshold, null), local.selected_profile.latency.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.latency.critical_threshold, null), local.selected_profile.latency.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.latency.window_minutes, null), local.selected_profile.latency.window_minutes)
    }
  }
}
