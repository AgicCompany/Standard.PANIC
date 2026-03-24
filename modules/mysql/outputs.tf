output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    cpu_warn                 = try(azurerm_monitor_metric_alert.cpu_warn[0].id, null)
    cpu_crit                 = try(azurerm_monitor_metric_alert.cpu_crit[0].id, null)
    memory_warn              = try(azurerm_monitor_metric_alert.memory_warn[0].id, null)
    memory_crit              = try(azurerm_monitor_metric_alert.memory_crit[0].id, null)
    storage_warn             = try(azurerm_monitor_metric_alert.storage_warn[0].id, null)
    storage_crit             = try(azurerm_monitor_metric_alert.storage_crit[0].id, null)
    io_warn                  = try(azurerm_monitor_metric_alert.io_warn[0].id, null)
    io_crit                  = try(azurerm_monitor_metric_alert.io_crit[0].id, null)
    connections_warn         = try(azurerm_monitor_metric_alert.connections_warn[0].id, null)
    connections_crit         = try(azurerm_monitor_metric_alert.connections_crit[0].id, null)
    aborted_connections_warn = try(azurerm_monitor_metric_alert.aborted_connections_warn[0].id, null)
    aborted_connections_crit = try(azurerm_monitor_metric_alert.aborted_connections_crit[0].id, null)
    replication_lag_warn     = try(azurerm_monitor_metric_alert.replication_lag_warn[0].id, null)
    replication_lag_crit     = try(azurerm_monitor_metric_alert.replication_lag_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    cpu_warn                 = try(azurerm_monitor_metric_alert.cpu_warn[0].name, null)
    cpu_crit                 = try(azurerm_monitor_metric_alert.cpu_crit[0].name, null)
    memory_warn              = try(azurerm_monitor_metric_alert.memory_warn[0].name, null)
    memory_crit              = try(azurerm_monitor_metric_alert.memory_crit[0].name, null)
    storage_warn             = try(azurerm_monitor_metric_alert.storage_warn[0].name, null)
    storage_crit             = try(azurerm_monitor_metric_alert.storage_crit[0].name, null)
    io_warn                  = try(azurerm_monitor_metric_alert.io_warn[0].name, null)
    io_crit                  = try(azurerm_monitor_metric_alert.io_crit[0].name, null)
    connections_warn         = try(azurerm_monitor_metric_alert.connections_warn[0].name, null)
    connections_crit         = try(azurerm_monitor_metric_alert.connections_crit[0].name, null)
    aborted_connections_warn = try(azurerm_monitor_metric_alert.aborted_connections_warn[0].name, null)
    aborted_connections_crit = try(azurerm_monitor_metric_alert.aborted_connections_crit[0].name, null)
    replication_lag_warn     = try(azurerm_monitor_metric_alert.replication_lag_warn[0].name, null)
    replication_lag_crit     = try(azurerm_monitor_metric_alert.replication_lag_crit[0].name, null)
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
