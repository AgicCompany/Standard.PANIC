locals {
  metric_namespace = "Microsoft.Network/loadBalancers"

  metrics = {
    health_probe_status = {
      name        = "DipAvailability"
      aggregation = "Average"
      description = "Backend pool health probe status"
    }
    data_path_availability = {
      name        = "VipAvailability"
      aggregation = "Average"
      description = "Load balancer data path availability"
    }
    snat_connection_count = {
      name        = "SnatConnectionCount"
      aggregation = "Total"
      description = "SNAT connection count"
    }
    used_snat_ports = {
      name        = "UsedSnatPorts"
      aggregation = "Average"
      description = "Used SNAT ports percentage"
    }
  }

  # Resolve final values: override -> profile -> defaults
  selected_profile = local.profiles[var.profile]

  resolved = {
    health_probe_status = {
      enabled            = coalesce(try(var.overrides.health_probe_status.enabled, null), local.selected_profile.health_probe_status.enabled)
      critical_threshold = coalesce(try(var.overrides.health_probe_status.critical_threshold, null), local.selected_profile.health_probe_status.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.health_probe_status.window_minutes, null), local.selected_profile.health_probe_status.window_minutes)
    }
    data_path_availability = {
      enabled            = coalesce(try(var.overrides.data_path_availability.enabled, null), local.selected_profile.data_path_availability.enabled)
      warning_threshold  = coalesce(try(var.overrides.data_path_availability.warning_threshold, null), local.selected_profile.data_path_availability.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.data_path_availability.critical_threshold, null), local.selected_profile.data_path_availability.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.data_path_availability.window_minutes, null), local.selected_profile.data_path_availability.window_minutes)
    }
    snat_connection_count = {
      enabled            = coalesce(try(var.overrides.snat_connection_count.enabled, null), local.selected_profile.snat_connection_count.enabled)
      warning_threshold  = coalesce(try(var.overrides.snat_connection_count.warning_threshold, null), local.selected_profile.snat_connection_count.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.snat_connection_count.critical_threshold, null), local.selected_profile.snat_connection_count.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.snat_connection_count.window_minutes, null), local.selected_profile.snat_connection_count.window_minutes)
    }
    used_snat_ports = {
      enabled            = coalesce(try(var.overrides.used_snat_ports.enabled, null), local.selected_profile.used_snat_ports.enabled)
      warning_threshold  = coalesce(try(var.overrides.used_snat_ports.warning_threshold, null), local.selected_profile.used_snat_ports.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.used_snat_ports.critical_threshold, null), local.selected_profile.used_snat_ports.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.used_snat_ports.window_minutes, null), local.selected_profile.used_snat_ports.window_minutes)
    }
  }
}
