output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    http_5xx_warn        = try(azurerm_monitor_metric_alert.http_5xx_warn[0].id, null)
    http_5xx_crit        = try(azurerm_monitor_metric_alert.http_5xx_crit[0].id, null)
    http_4xx_warn        = try(azurerm_monitor_metric_alert.http_4xx_warn[0].id, null)
    http_4xx_crit        = try(azurerm_monitor_metric_alert.http_4xx_crit[0].id, null)
    response_time_warn   = try(azurerm_monitor_metric_alert.response_time_warn[0].id, null)
    response_time_crit   = try(azurerm_monitor_metric_alert.response_time_crit[0].id, null)
    memory_warn          = try(azurerm_monitor_metric_alert.memory_warn[0].id, null)
    memory_crit          = try(azurerm_monitor_metric_alert.memory_crit[0].id, null)
    execution_count_warn = try(azurerm_monitor_metric_alert.execution_count_warn[0].id, null)
    execution_count_crit = try(azurerm_monitor_metric_alert.execution_count_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    http_5xx_warn        = try(azurerm_monitor_metric_alert.http_5xx_warn[0].name, null)
    http_5xx_crit        = try(azurerm_monitor_metric_alert.http_5xx_crit[0].name, null)
    http_4xx_warn        = try(azurerm_monitor_metric_alert.http_4xx_warn[0].name, null)
    http_4xx_crit        = try(azurerm_monitor_metric_alert.http_4xx_crit[0].name, null)
    response_time_warn   = try(azurerm_monitor_metric_alert.response_time_warn[0].name, null)
    response_time_crit   = try(azurerm_monitor_metric_alert.response_time_crit[0].name, null)
    memory_warn          = try(azurerm_monitor_metric_alert.memory_warn[0].name, null)
    memory_crit          = try(azurerm_monitor_metric_alert.memory_crit[0].name, null)
    execution_count_warn = try(azurerm_monitor_metric_alert.execution_count_warn[0].name, null)
    execution_count_crit = try(azurerm_monitor_metric_alert.execution_count_crit[0].name, null)
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
