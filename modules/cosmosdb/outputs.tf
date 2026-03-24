output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    ru_consumption_warn     = try(azurerm_monitor_metric_alert.ru_consumption_warn[0].id, null)
    ru_consumption_crit     = try(azurerm_monitor_metric_alert.ru_consumption_crit[0].id, null)
    availability_warn       = try(azurerm_monitor_metric_alert.availability_warn[0].id, null)
    availability_crit       = try(azurerm_monitor_metric_alert.availability_crit[0].id, null)
    server_latency_warn     = try(azurerm_monitor_metric_alert.server_latency_warn[0].id, null)
    server_latency_crit     = try(azurerm_monitor_metric_alert.server_latency_crit[0].id, null)
    throttled_requests_warn = try(azurerm_monitor_metric_alert.throttled_requests_warn[0].id, null)
    throttled_requests_crit = try(azurerm_monitor_metric_alert.throttled_requests_crit[0].id, null)
    total_requests_warn     = try(azurerm_monitor_metric_alert.total_requests_warn[0].id, null)
    total_requests_crit     = try(azurerm_monitor_metric_alert.total_requests_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    ru_consumption_warn     = try(azurerm_monitor_metric_alert.ru_consumption_warn[0].name, null)
    ru_consumption_crit     = try(azurerm_monitor_metric_alert.ru_consumption_crit[0].name, null)
    availability_warn       = try(azurerm_monitor_metric_alert.availability_warn[0].name, null)
    availability_crit       = try(azurerm_monitor_metric_alert.availability_crit[0].name, null)
    server_latency_warn     = try(azurerm_monitor_metric_alert.server_latency_warn[0].name, null)
    server_latency_crit     = try(azurerm_monitor_metric_alert.server_latency_crit[0].name, null)
    throttled_requests_warn = try(azurerm_monitor_metric_alert.throttled_requests_warn[0].name, null)
    throttled_requests_crit = try(azurerm_monitor_metric_alert.throttled_requests_crit[0].name, null)
    total_requests_warn     = try(azurerm_monitor_metric_alert.total_requests_warn[0].name, null)
    total_requests_crit     = try(azurerm_monitor_metric_alert.total_requests_crit[0].name, null)
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
