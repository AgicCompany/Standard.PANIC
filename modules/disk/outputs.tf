output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    iops_consumed_warn      = try(azurerm_monitor_metric_alert.iops_consumed_warn[0].id, null)
    iops_consumed_crit      = try(azurerm_monitor_metric_alert.iops_consumed_crit[0].id, null)
    bandwidth_consumed_warn = try(azurerm_monitor_metric_alert.bandwidth_consumed_warn[0].id, null)
    bandwidth_consumed_crit = try(azurerm_monitor_metric_alert.bandwidth_consumed_crit[0].id, null)
    queue_depth_warn        = try(azurerm_monitor_metric_alert.queue_depth_warn[0].id, null)
    queue_depth_crit        = try(azurerm_monitor_metric_alert.queue_depth_crit[0].id, null)
    burst_bps_credits_warn  = try(azurerm_monitor_metric_alert.burst_bps_credits_warn[0].id, null)
    burst_bps_credits_crit  = try(azurerm_monitor_metric_alert.burst_bps_credits_crit[0].id, null)
    burst_io_credits_warn   = try(azurerm_monitor_metric_alert.burst_io_credits_warn[0].id, null)
    burst_io_credits_crit   = try(azurerm_monitor_metric_alert.burst_io_credits_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    iops_consumed_warn      = try(azurerm_monitor_metric_alert.iops_consumed_warn[0].name, null)
    iops_consumed_crit      = try(azurerm_monitor_metric_alert.iops_consumed_crit[0].name, null)
    bandwidth_consumed_warn = try(azurerm_monitor_metric_alert.bandwidth_consumed_warn[0].name, null)
    bandwidth_consumed_crit = try(azurerm_monitor_metric_alert.bandwidth_consumed_crit[0].name, null)
    queue_depth_warn        = try(azurerm_monitor_metric_alert.queue_depth_warn[0].name, null)
    queue_depth_crit        = try(azurerm_monitor_metric_alert.queue_depth_crit[0].name, null)
    burst_bps_credits_warn  = try(azurerm_monitor_metric_alert.burst_bps_credits_warn[0].name, null)
    burst_bps_credits_crit  = try(azurerm_monitor_metric_alert.burst_bps_credits_crit[0].name, null)
    burst_io_credits_warn   = try(azurerm_monitor_metric_alert.burst_io_credits_warn[0].name, null)
    burst_io_credits_crit   = try(azurerm_monitor_metric_alert.burst_io_credits_crit[0].name, null)
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
