output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    availability_warn = try(azurerm_monitor_metric_alert.availability_warn[0].id, null)
    availability_crit = try(azurerm_monitor_metric_alert.availability_crit[0].id, null)
    latency_warn      = try(azurerm_monitor_metric_alert.latency_warn[0].id, null)
    latency_crit      = try(azurerm_monitor_metric_alert.latency_crit[0].id, null)
    saturation_warn   = try(azurerm_monitor_metric_alert.saturation_warn[0].id, null)
    saturation_crit   = try(azurerm_monitor_metric_alert.saturation_crit[0].id, null)
    api_hits_warn     = try(azurerm_monitor_metric_alert.api_hits_warn[0].id, null)
    api_hits_crit     = try(azurerm_monitor_metric_alert.api_hits_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    availability_warn = try(azurerm_monitor_metric_alert.availability_warn[0].name, null)
    availability_crit = try(azurerm_monitor_metric_alert.availability_crit[0].name, null)
    latency_warn      = try(azurerm_monitor_metric_alert.latency_warn[0].name, null)
    latency_crit      = try(azurerm_monitor_metric_alert.latency_crit[0].name, null)
    saturation_warn   = try(azurerm_monitor_metric_alert.saturation_warn[0].name, null)
    saturation_crit   = try(azurerm_monitor_metric_alert.saturation_crit[0].name, null)
    api_hits_warn     = try(azurerm_monitor_metric_alert.api_hits_warn[0].name, null)
    api_hits_crit     = try(azurerm_monitor_metric_alert.api_hits_crit[0].name, null)
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
