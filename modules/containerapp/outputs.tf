output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    cpu_warn      = try(azurerm_monitor_metric_alert.cpu_warn[0].id, null)
    cpu_crit      = try(azurerm_monitor_metric_alert.cpu_crit[0].id, null)
    memory_warn   = try(azurerm_monitor_metric_alert.memory_warn[0].id, null)
    memory_crit   = try(azurerm_monitor_metric_alert.memory_crit[0].id, null)
    restarts_warn = try(azurerm_monitor_metric_alert.restarts_warn[0].id, null)
    restarts_crit = try(azurerm_monitor_metric_alert.restarts_crit[0].id, null)
    replicas_warn = try(azurerm_monitor_metric_alert.replicas_warn[0].id, null)
    replicas_crit = try(azurerm_monitor_metric_alert.replicas_crit[0].id, null)
    requests_warn = try(azurerm_monitor_metric_alert.requests_warn[0].id, null)
    requests_crit = try(azurerm_monitor_metric_alert.requests_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    cpu_warn      = try(azurerm_monitor_metric_alert.cpu_warn[0].name, null)
    cpu_crit      = try(azurerm_monitor_metric_alert.cpu_crit[0].name, null)
    memory_warn   = try(azurerm_monitor_metric_alert.memory_warn[0].name, null)
    memory_crit   = try(azurerm_monitor_metric_alert.memory_crit[0].name, null)
    restarts_warn = try(azurerm_monitor_metric_alert.restarts_warn[0].name, null)
    restarts_crit = try(azurerm_monitor_metric_alert.restarts_crit[0].name, null)
    replicas_warn = try(azurerm_monitor_metric_alert.replicas_warn[0].name, null)
    replicas_crit = try(azurerm_monitor_metric_alert.replicas_crit[0].name, null)
    requests_warn = try(azurerm_monitor_metric_alert.requests_warn[0].name, null)
    requests_crit = try(azurerm_monitor_metric_alert.requests_crit[0].name, null)
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
