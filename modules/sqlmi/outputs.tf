output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    cpu_warn         = try(azurerm_monitor_metric_alert.cpu_warn[0].id, null)
    cpu_crit         = try(azurerm_monitor_metric_alert.cpu_crit[0].id, null)
    storage_warn     = try(azurerm_monitor_metric_alert.storage_warn[0].id, null)
    storage_crit     = try(azurerm_monitor_metric_alert.storage_crit[0].id, null)
    io_requests_warn = try(azurerm_monitor_metric_alert.io_requests_warn[0].id, null)
    io_requests_crit = try(azurerm_monitor_metric_alert.io_requests_crit[0].id, null)
    io_bytes_warn    = try(azurerm_monitor_metric_alert.io_bytes_warn[0].id, null)
    io_bytes_crit    = try(azurerm_monitor_metric_alert.io_bytes_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    cpu_warn         = try(azurerm_monitor_metric_alert.cpu_warn[0].name, null)
    cpu_crit         = try(azurerm_monitor_metric_alert.cpu_crit[0].name, null)
    storage_warn     = try(azurerm_monitor_metric_alert.storage_warn[0].name, null)
    storage_crit     = try(azurerm_monitor_metric_alert.storage_crit[0].name, null)
    io_requests_warn = try(azurerm_monitor_metric_alert.io_requests_warn[0].name, null)
    io_requests_crit = try(azurerm_monitor_metric_alert.io_requests_crit[0].name, null)
    io_bytes_warn    = try(azurerm_monitor_metric_alert.io_bytes_warn[0].name, null)
    io_bytes_crit    = try(azurerm_monitor_metric_alert.io_bytes_crit[0].name, null)
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
