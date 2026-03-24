output "alert_ids" {
  description = "Map of all created alert rule IDs"
  value = {
    availability_warn   = try(azurerm_monitor_metric_alert.availability_warn[0].id, null)
    availability_crit   = try(azurerm_monitor_metric_alert.availability_crit[0].id, null)
    latency_warn        = try(azurerm_monitor_metric_alert.latency_warn[0].id, null)
    latency_crit        = try(azurerm_monitor_metric_alert.latency_crit[0].id, null)
    throttling_warn     = try(azurerm_monitor_metric_alert.throttling_warn[0].id, null)
    throttling_crit     = try(azurerm_monitor_metric_alert.throttling_crit[0].id, null)
    used_capacity_warn  = try(azurerm_monitor_metric_alert.used_capacity_warn[0].id, null)
    used_capacity_crit  = try(azurerm_monitor_metric_alert.used_capacity_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of all created alert rule names"
  value = {
    availability_warn   = try(azurerm_monitor_metric_alert.availability_warn[0].name, null)
    availability_crit   = try(azurerm_monitor_metric_alert.availability_crit[0].name, null)
    latency_warn        = try(azurerm_monitor_metric_alert.latency_warn[0].name, null)
    latency_crit        = try(azurerm_monitor_metric_alert.latency_crit[0].name, null)
    throttling_warn     = try(azurerm_monitor_metric_alert.throttling_warn[0].name, null)
    throttling_crit     = try(azurerm_monitor_metric_alert.throttling_crit[0].name, null)
    used_capacity_warn  = try(azurerm_monitor_metric_alert.used_capacity_warn[0].name, null)
    used_capacity_crit  = try(azurerm_monitor_metric_alert.used_capacity_crit[0].name, null)
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
