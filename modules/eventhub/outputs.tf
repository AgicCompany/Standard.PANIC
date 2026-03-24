output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    throttled_requests_warn = try(azurerm_monitor_metric_alert.throttled_requests_warn[0].id, null)
    throttled_requests_crit = try(azurerm_monitor_metric_alert.throttled_requests_crit[0].id, null)
    quota_exceeded_warn     = try(azurerm_monitor_metric_alert.quota_exceeded_warn[0].id, null)
    quota_exceeded_crit     = try(azurerm_monitor_metric_alert.quota_exceeded_crit[0].id, null)
    server_errors_warn      = try(azurerm_monitor_metric_alert.server_errors_warn[0].id, null)
    server_errors_crit      = try(azurerm_monitor_metric_alert.server_errors_crit[0].id, null)
    incoming_messages_warn  = try(azurerm_monitor_metric_alert.incoming_messages_warn[0].id, null)
    incoming_messages_crit  = try(azurerm_monitor_metric_alert.incoming_messages_crit[0].id, null)
    capture_backlog_warn    = try(azurerm_monitor_metric_alert.capture_backlog_warn[0].id, null)
    capture_backlog_crit    = try(azurerm_monitor_metric_alert.capture_backlog_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    throttled_requests_warn = try(azurerm_monitor_metric_alert.throttled_requests_warn[0].name, null)
    throttled_requests_crit = try(azurerm_monitor_metric_alert.throttled_requests_crit[0].name, null)
    quota_exceeded_warn     = try(azurerm_monitor_metric_alert.quota_exceeded_warn[0].name, null)
    quota_exceeded_crit     = try(azurerm_monitor_metric_alert.quota_exceeded_crit[0].name, null)
    server_errors_warn      = try(azurerm_monitor_metric_alert.server_errors_warn[0].name, null)
    server_errors_crit      = try(azurerm_monitor_metric_alert.server_errors_crit[0].name, null)
    incoming_messages_warn  = try(azurerm_monitor_metric_alert.incoming_messages_warn[0].name, null)
    incoming_messages_crit  = try(azurerm_monitor_metric_alert.incoming_messages_crit[0].name, null)
    capture_backlog_warn    = try(azurerm_monitor_metric_alert.capture_backlog_warn[0].name, null)
    capture_backlog_crit    = try(azurerm_monitor_metric_alert.capture_backlog_crit[0].name, null)
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
