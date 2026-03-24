output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    health_state_warn          = try(azurerm_monitor_metric_alert.health_state_warn[0].id, null)
    health_state_crit          = try(azurerm_monitor_metric_alert.health_state_crit[0].id, null)
    throughput_warn            = try(azurerm_monitor_metric_alert.throughput_warn[0].id, null)
    throughput_crit            = try(azurerm_monitor_metric_alert.throughput_crit[0].id, null)
    snat_port_utilization_warn = try(azurerm_monitor_metric_alert.snat_port_utilization_warn[0].id, null)
    snat_port_utilization_crit = try(azurerm_monitor_metric_alert.snat_port_utilization_crit[0].id, null)
    latency_warn               = try(azurerm_monitor_metric_alert.latency_warn[0].id, null)
    latency_crit               = try(azurerm_monitor_metric_alert.latency_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    health_state_warn          = try(azurerm_monitor_metric_alert.health_state_warn[0].name, null)
    health_state_crit          = try(azurerm_monitor_metric_alert.health_state_crit[0].name, null)
    throughput_warn            = try(azurerm_monitor_metric_alert.throughput_warn[0].name, null)
    throughput_crit            = try(azurerm_monitor_metric_alert.throughput_crit[0].name, null)
    snat_port_utilization_warn = try(azurerm_monitor_metric_alert.snat_port_utilization_warn[0].name, null)
    snat_port_utilization_crit = try(azurerm_monitor_metric_alert.snat_port_utilization_crit[0].name, null)
    latency_warn               = try(azurerm_monitor_metric_alert.latency_warn[0].name, null)
    latency_crit               = try(azurerm_monitor_metric_alert.latency_crit[0].name, null)
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
