locals {
  metric_namespace = "Microsoft.Network/virtualNetworkGateways"

  metrics = {
    tunnel_status = {
      name        = "TunnelAverageBandwidth"
      aggregation = "Average"
      description = "VPN tunnel connection status"
    }
    tunnel_bandwidth = {
      name        = "TunnelAverageBandwidth"
      aggregation = "Average"
      description = "Tunnel average bandwidth in bytes per second"
    }
    p2s_bandwidth = {
      name        = "P2SBandwidth"
      aggregation = "Average"
      description = "Point-to-site bandwidth in bytes per second"
    }
    p2s_connection_count = {
      name        = "P2SConnectionCount"
      aggregation = "Total"
      description = "Point-to-site connection count"
    }
    tunnel_drop_count = {
      name        = "TunnelDropCount"
      aggregation = "Total"
      description = "Count of dropped tunnel packets"
    }
  }

  # Resolve final values: override -> profile -> defaults
  selected_profile = local.profiles[var.profile]

  resolved = {
    tunnel_status = {
      enabled            = coalesce(try(var.overrides.tunnel_status.enabled, null), local.selected_profile.tunnel_status.enabled)
      critical_threshold = coalesce(try(var.overrides.tunnel_status.critical_threshold, null), local.selected_profile.tunnel_status.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.tunnel_status.window_minutes, null), local.selected_profile.tunnel_status.window_minutes)
    }
    tunnel_bandwidth = {
      enabled            = coalesce(try(var.overrides.tunnel_bandwidth.enabled, null), local.selected_profile.tunnel_bandwidth.enabled)
      warning_threshold  = coalesce(try(var.overrides.tunnel_bandwidth.warning_threshold, null), local.selected_profile.tunnel_bandwidth.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.tunnel_bandwidth.critical_threshold, null), local.selected_profile.tunnel_bandwidth.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.tunnel_bandwidth.window_minutes, null), local.selected_profile.tunnel_bandwidth.window_minutes)
    }
    p2s_bandwidth = {
      enabled            = coalesce(try(var.overrides.p2s_bandwidth.enabled, null), local.selected_profile.p2s_bandwidth.enabled)
      warning_threshold  = coalesce(try(var.overrides.p2s_bandwidth.warning_threshold, null), local.selected_profile.p2s_bandwidth.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.p2s_bandwidth.critical_threshold, null), local.selected_profile.p2s_bandwidth.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.p2s_bandwidth.window_minutes, null), local.selected_profile.p2s_bandwidth.window_minutes)
    }
    p2s_connection_count = {
      enabled            = coalesce(try(var.overrides.p2s_connection_count.enabled, null), local.selected_profile.p2s_connection_count.enabled)
      warning_threshold  = coalesce(try(var.overrides.p2s_connection_count.warning_threshold, null), local.selected_profile.p2s_connection_count.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.p2s_connection_count.critical_threshold, null), local.selected_profile.p2s_connection_count.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.p2s_connection_count.window_minutes, null), local.selected_profile.p2s_connection_count.window_minutes)
    }
    tunnel_drop_count = {
      enabled            = coalesce(try(var.overrides.tunnel_drop_count.enabled, null), local.selected_profile.tunnel_drop_count.enabled)
      warning_threshold  = coalesce(try(var.overrides.tunnel_drop_count.warning_threshold, null), local.selected_profile.tunnel_drop_count.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.tunnel_drop_count.critical_threshold, null), local.selected_profile.tunnel_drop_count.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.tunnel_drop_count.window_minutes, null), local.selected_profile.tunnel_drop_count.window_minutes)
    }
  }
}
