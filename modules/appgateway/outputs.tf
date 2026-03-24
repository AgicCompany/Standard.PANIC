output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    unhealthy_hosts_warn = try(azurerm_monitor_metric_alert.unhealthy_hosts_warn[0].id, null)
    unhealthy_hosts_crit = try(azurerm_monitor_metric_alert.unhealthy_hosts_crit[0].id, null)
    backend_5xx_warn     = try(azurerm_monitor_metric_alert.backend_5xx_warn[0].id, null)
    backend_5xx_crit     = try(azurerm_monitor_metric_alert.backend_5xx_crit[0].id, null)
    cpu_warn             = try(azurerm_monitor_metric_alert.cpu_warn[0].id, null)
    cpu_crit             = try(azurerm_monitor_metric_alert.cpu_crit[0].id, null)
    capacity_units_warn  = try(azurerm_monitor_metric_alert.capacity_units_warn[0].id, null)
    capacity_units_crit  = try(azurerm_monitor_metric_alert.capacity_units_crit[0].id, null)
    failed_requests_warn = try(azurerm_monitor_metric_alert.failed_requests_warn[0].id, null)
    failed_requests_crit = try(azurerm_monitor_metric_alert.failed_requests_crit[0].id, null)
    response_5xx_warn    = try(azurerm_monitor_metric_alert.response_5xx_warn[0].id, null)
    response_5xx_crit    = try(azurerm_monitor_metric_alert.response_5xx_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    unhealthy_hosts_warn = try(azurerm_monitor_metric_alert.unhealthy_hosts_warn[0].name, null)
    unhealthy_hosts_crit = try(azurerm_monitor_metric_alert.unhealthy_hosts_crit[0].name, null)
    backend_5xx_warn     = try(azurerm_monitor_metric_alert.backend_5xx_warn[0].name, null)
    backend_5xx_crit     = try(azurerm_monitor_metric_alert.backend_5xx_crit[0].name, null)
    cpu_warn             = try(azurerm_monitor_metric_alert.cpu_warn[0].name, null)
    cpu_crit             = try(azurerm_monitor_metric_alert.cpu_crit[0].name, null)
    capacity_units_warn  = try(azurerm_monitor_metric_alert.capacity_units_warn[0].name, null)
    capacity_units_crit  = try(azurerm_monitor_metric_alert.capacity_units_crit[0].name, null)
    failed_requests_warn = try(azurerm_monitor_metric_alert.failed_requests_warn[0].name, null)
    failed_requests_crit = try(azurerm_monitor_metric_alert.failed_requests_crit[0].name, null)
    response_5xx_warn    = try(azurerm_monitor_metric_alert.response_5xx_warn[0].name, null)
    response_5xx_crit    = try(azurerm_monitor_metric_alert.response_5xx_crit[0].name, null)
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
