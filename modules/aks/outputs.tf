output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    node_cpu_warn    = try(azurerm_monitor_metric_alert.node_cpu_warn[0].id, null)
    node_cpu_crit    = try(azurerm_monitor_metric_alert.node_cpu_crit[0].id, null)
    node_memory_warn = try(azurerm_monitor_metric_alert.node_memory_warn[0].id, null)
    node_memory_crit = try(azurerm_monitor_metric_alert.node_memory_crit[0].id, null)
    node_disk_warn   = try(azurerm_monitor_metric_alert.node_disk_warn[0].id, null)
    node_disk_crit   = try(azurerm_monitor_metric_alert.node_disk_crit[0].id, null)
    pod_ready_warn   = try(azurerm_monitor_metric_alert.pod_ready_warn[0].id, null)
    pod_ready_crit   = try(azurerm_monitor_metric_alert.pod_ready_crit[0].id, null)
    node_count_warn  = try(azurerm_monitor_metric_alert.node_count_warn[0].id, null)
    node_count_crit  = try(azurerm_monitor_metric_alert.node_count_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    node_cpu_warn    = try(azurerm_monitor_metric_alert.node_cpu_warn[0].name, null)
    node_cpu_crit    = try(azurerm_monitor_metric_alert.node_cpu_crit[0].name, null)
    node_memory_warn = try(azurerm_monitor_metric_alert.node_memory_warn[0].name, null)
    node_memory_crit = try(azurerm_monitor_metric_alert.node_memory_crit[0].name, null)
    node_disk_warn   = try(azurerm_monitor_metric_alert.node_disk_warn[0].name, null)
    node_disk_crit   = try(azurerm_monitor_metric_alert.node_disk_crit[0].name, null)
    pod_ready_warn   = try(azurerm_monitor_metric_alert.pod_ready_warn[0].name, null)
    pod_ready_crit   = try(azurerm_monitor_metric_alert.pod_ready_crit[0].name, null)
    node_count_warn  = try(azurerm_monitor_metric_alert.node_count_warn[0].name, null)
    node_count_crit  = try(azurerm_monitor_metric_alert.node_count_crit[0].name, null)
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
