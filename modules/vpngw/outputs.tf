output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    tunnel_status_crit        = try(azurerm_monitor_metric_alert.tunnel_status_crit[0].id, null)
    tunnel_bandwidth_warn     = try(azurerm_monitor_metric_alert.tunnel_bandwidth_warn[0].id, null)
    tunnel_bandwidth_crit     = try(azurerm_monitor_metric_alert.tunnel_bandwidth_crit[0].id, null)
    p2s_bandwidth_warn        = try(azurerm_monitor_metric_alert.p2s_bandwidth_warn[0].id, null)
    p2s_bandwidth_crit        = try(azurerm_monitor_metric_alert.p2s_bandwidth_crit[0].id, null)
    p2s_connection_count_warn = try(azurerm_monitor_metric_alert.p2s_connection_count_warn[0].id, null)
    p2s_connection_count_crit = try(azurerm_monitor_metric_alert.p2s_connection_count_crit[0].id, null)
    tunnel_drop_count_warn    = try(azurerm_monitor_metric_alert.tunnel_drop_count_warn[0].id, null)
    tunnel_drop_count_crit    = try(azurerm_monitor_metric_alert.tunnel_drop_count_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    tunnel_status_crit        = try(azurerm_monitor_metric_alert.tunnel_status_crit[0].name, null)
    tunnel_bandwidth_warn     = try(azurerm_monitor_metric_alert.tunnel_bandwidth_warn[0].name, null)
    tunnel_bandwidth_crit     = try(azurerm_monitor_metric_alert.tunnel_bandwidth_crit[0].name, null)
    p2s_bandwidth_warn        = try(azurerm_monitor_metric_alert.p2s_bandwidth_warn[0].name, null)
    p2s_bandwidth_crit        = try(azurerm_monitor_metric_alert.p2s_bandwidth_crit[0].name, null)
    p2s_connection_count_warn = try(azurerm_monitor_metric_alert.p2s_connection_count_warn[0].name, null)
    p2s_connection_count_crit = try(azurerm_monitor_metric_alert.p2s_connection_count_crit[0].name, null)
    tunnel_drop_count_warn    = try(azurerm_monitor_metric_alert.tunnel_drop_count_warn[0].name, null)
    tunnel_drop_count_crit    = try(azurerm_monitor_metric_alert.tunnel_drop_count_crit[0].name, null)
  }
}

output "profile" {
  description = "The alert profile used"
  value       = var.profile
}

output "resolved_thresholds" {
  description = "Final threshold values after applying overrides"
  value       = local.resolved
}
