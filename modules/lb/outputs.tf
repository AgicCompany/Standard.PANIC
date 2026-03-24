output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    health_probe_status_crit    = try(azurerm_monitor_metric_alert.health_probe_status_crit[0].id, null)
    data_path_availability_warn = try(azurerm_monitor_metric_alert.data_path_availability_warn[0].id, null)
    data_path_availability_crit = try(azurerm_monitor_metric_alert.data_path_availability_crit[0].id, null)
    snat_connection_count_warn  = try(azurerm_monitor_metric_alert.snat_connection_count_warn[0].id, null)
    snat_connection_count_crit  = try(azurerm_monitor_metric_alert.snat_connection_count_crit[0].id, null)
    used_snat_ports_warn        = try(azurerm_monitor_metric_alert.used_snat_ports_warn[0].id, null)
    used_snat_ports_crit        = try(azurerm_monitor_metric_alert.used_snat_ports_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    health_probe_status_crit    = try(azurerm_monitor_metric_alert.health_probe_status_crit[0].name, null)
    data_path_availability_warn = try(azurerm_monitor_metric_alert.data_path_availability_warn[0].name, null)
    data_path_availability_crit = try(azurerm_monitor_metric_alert.data_path_availability_crit[0].name, null)
    snat_connection_count_warn  = try(azurerm_monitor_metric_alert.snat_connection_count_warn[0].name, null)
    snat_connection_count_crit  = try(azurerm_monitor_metric_alert.snat_connection_count_crit[0].name, null)
    used_snat_ports_warn        = try(azurerm_monitor_metric_alert.used_snat_ports_warn[0].name, null)
    used_snat_ports_crit        = try(azurerm_monitor_metric_alert.used_snat_ports_crit[0].name, null)
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
