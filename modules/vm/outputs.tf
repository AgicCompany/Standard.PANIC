output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    cpu_warn           = try(azurerm_monitor_metric_alert.cpu_warn[0].id, null)
    cpu_crit           = try(azurerm_monitor_metric_alert.cpu_crit[0].id, null)
    memory_warn        = try(azurerm_monitor_metric_alert.memory_warn[0].id, null)
    memory_crit        = try(azurerm_monitor_metric_alert.memory_crit[0].id, null)
    os_disk_iops_warn  = try(azurerm_monitor_metric_alert.os_disk_iops_warn[0].id, null)
    os_disk_iops_crit  = try(azurerm_monitor_metric_alert.os_disk_iops_crit[0].id, null)
    data_disk_iops_warn = try(azurerm_monitor_metric_alert.data_disk_iops_warn[0].id, null)
    data_disk_iops_crit = try(azurerm_monitor_metric_alert.data_disk_iops_crit[0].id, null)
    disk_free_warn     = try(azurerm_monitor_metric_alert.disk_free_warn[0].id, null)
    disk_free_crit     = try(azurerm_monitor_metric_alert.disk_free_crit[0].id, null)
    availability_crit  = try(azurerm_monitor_metric_alert.availability_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    cpu_warn           = try(azurerm_monitor_metric_alert.cpu_warn[0].name, null)
    cpu_crit           = try(azurerm_monitor_metric_alert.cpu_crit[0].name, null)
    memory_warn        = try(azurerm_monitor_metric_alert.memory_warn[0].name, null)
    memory_crit        = try(azurerm_monitor_metric_alert.memory_crit[0].name, null)
    os_disk_iops_warn  = try(azurerm_monitor_metric_alert.os_disk_iops_warn[0].name, null)
    os_disk_iops_crit  = try(azurerm_monitor_metric_alert.os_disk_iops_crit[0].name, null)
    data_disk_iops_warn = try(azurerm_monitor_metric_alert.data_disk_iops_warn[0].name, null)
    data_disk_iops_crit = try(azurerm_monitor_metric_alert.data_disk_iops_crit[0].name, null)
    disk_free_warn     = try(azurerm_monitor_metric_alert.disk_free_warn[0].name, null)
    disk_free_crit     = try(azurerm_monitor_metric_alert.disk_free_crit[0].name, null)
    availability_crit  = try(azurerm_monitor_metric_alert.availability_crit[0].name, null)
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
