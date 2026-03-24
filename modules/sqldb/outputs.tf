output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    cpu_warn               = try(azurerm_monitor_metric_alert.cpu_warn[0].id, null)
    cpu_crit               = try(azurerm_monitor_metric_alert.cpu_crit[0].id, null)
    dtu_warn               = try(azurerm_monitor_metric_alert.dtu_warn[0].id, null)
    dtu_crit               = try(azurerm_monitor_metric_alert.dtu_crit[0].id, null)
    storage_warn           = try(azurerm_monitor_metric_alert.storage_warn[0].id, null)
    storage_crit           = try(azurerm_monitor_metric_alert.storage_crit[0].id, null)
    deadlocks_warn         = try(azurerm_monitor_metric_alert.deadlocks_warn[0].id, null)
    deadlocks_crit         = try(azurerm_monitor_metric_alert.deadlocks_crit[0].id, null)
    connection_failed_warn = try(azurerm_monitor_metric_alert.connection_failed_warn[0].id, null)
    connection_failed_crit = try(azurerm_monitor_metric_alert.connection_failed_crit[0].id, null)
    sessions_warn          = try(azurerm_monitor_metric_alert.sessions_warn[0].id, null)
    sessions_crit          = try(azurerm_monitor_metric_alert.sessions_crit[0].id, null)
    workers_warn           = try(azurerm_monitor_metric_alert.workers_warn[0].id, null)
    workers_crit           = try(azurerm_monitor_metric_alert.workers_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    cpu_warn               = try(azurerm_monitor_metric_alert.cpu_warn[0].name, null)
    cpu_crit               = try(azurerm_monitor_metric_alert.cpu_crit[0].name, null)
    dtu_warn               = try(azurerm_monitor_metric_alert.dtu_warn[0].name, null)
    dtu_crit               = try(azurerm_monitor_metric_alert.dtu_crit[0].name, null)
    storage_warn           = try(azurerm_monitor_metric_alert.storage_warn[0].name, null)
    storage_crit           = try(azurerm_monitor_metric_alert.storage_crit[0].name, null)
    deadlocks_warn         = try(azurerm_monitor_metric_alert.deadlocks_warn[0].name, null)
    deadlocks_crit         = try(azurerm_monitor_metric_alert.deadlocks_crit[0].name, null)
    connection_failed_warn = try(azurerm_monitor_metric_alert.connection_failed_warn[0].name, null)
    connection_failed_crit = try(azurerm_monitor_metric_alert.connection_failed_crit[0].name, null)
    sessions_warn          = try(azurerm_monitor_metric_alert.sessions_warn[0].name, null)
    sessions_crit          = try(azurerm_monitor_metric_alert.sessions_crit[0].name, null)
    workers_warn           = try(azurerm_monitor_metric_alert.workers_warn[0].name, null)
    workers_crit           = try(azurerm_monitor_metric_alert.workers_crit[0].name, null)
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
