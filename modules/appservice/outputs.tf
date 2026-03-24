output "alert_ids" {
  description = "Map of all created alert rule IDs"
  value = {
    cpu_warn           = try(azurerm_monitor_metric_alert.cpu_warn[0].id, null)
    cpu_crit           = try(azurerm_monitor_metric_alert.cpu_crit[0].id, null)
    memory_warn        = try(azurerm_monitor_metric_alert.memory_warn[0].id, null)
    memory_crit        = try(azurerm_monitor_metric_alert.memory_crit[0].id, null)
    http_5xx_warn      = try(azurerm_monitor_metric_alert.http_5xx_warn[0].id, null)
    http_5xx_crit      = try(azurerm_monitor_metric_alert.http_5xx_crit[0].id, null)
    response_time_warn = try(azurerm_monitor_metric_alert.response_time_warn[0].id, null)
    response_time_crit = try(azurerm_monitor_metric_alert.response_time_crit[0].id, null)
    health_check_crit  = try(azurerm_monitor_metric_alert.health_check_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of all created alert rule names"
  value = {
    cpu_warn           = try(azurerm_monitor_metric_alert.cpu_warn[0].name, null)
    cpu_crit           = try(azurerm_monitor_metric_alert.cpu_crit[0].name, null)
    memory_warn        = try(azurerm_monitor_metric_alert.memory_warn[0].name, null)
    memory_crit        = try(azurerm_monitor_metric_alert.memory_crit[0].name, null)
    http_5xx_warn      = try(azurerm_monitor_metric_alert.http_5xx_warn[0].name, null)
    http_5xx_crit      = try(azurerm_monitor_metric_alert.http_5xx_crit[0].name, null)
    response_time_warn = try(azurerm_monitor_metric_alert.response_time_warn[0].name, null)
    response_time_crit = try(azurerm_monitor_metric_alert.response_time_crit[0].name, null)
    health_check_crit  = try(azurerm_monitor_metric_alert.health_check_crit[0].name, null)
  }
}

output "profile" {
  description = "The alert profile used"
  value       = var.profile
}

output "resolved_thresholds" {
  description = "The resolved threshold values after applying overrides"
  value       = local.resolved
}
