output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    active_messages_warn       = try(azurerm_monitor_metric_alert.active_messages_warn[0].id, null)
    active_messages_crit       = try(azurerm_monitor_metric_alert.active_messages_crit[0].id, null)
    deadlettered_messages_warn = try(azurerm_monitor_metric_alert.deadlettered_messages_warn[0].id, null)
    deadlettered_messages_crit = try(azurerm_monitor_metric_alert.deadlettered_messages_crit[0].id, null)
    throttled_requests_warn    = try(azurerm_monitor_metric_alert.throttled_requests_warn[0].id, null)
    throttled_requests_crit    = try(azurerm_monitor_metric_alert.throttled_requests_crit[0].id, null)
    server_errors_warn         = try(azurerm_monitor_metric_alert.server_errors_warn[0].id, null)
    server_errors_crit         = try(azurerm_monitor_metric_alert.server_errors_crit[0].id, null)
    size_warn                  = try(azurerm_monitor_metric_alert.size_warn[0].id, null)
    size_crit                  = try(azurerm_monitor_metric_alert.size_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    active_messages_warn       = try(azurerm_monitor_metric_alert.active_messages_warn[0].name, null)
    active_messages_crit       = try(azurerm_monitor_metric_alert.active_messages_crit[0].name, null)
    deadlettered_messages_warn = try(azurerm_monitor_metric_alert.deadlettered_messages_warn[0].name, null)
    deadlettered_messages_crit = try(azurerm_monitor_metric_alert.deadlettered_messages_crit[0].name, null)
    throttled_requests_warn    = try(azurerm_monitor_metric_alert.throttled_requests_warn[0].name, null)
    throttled_requests_crit    = try(azurerm_monitor_metric_alert.throttled_requests_crit[0].name, null)
    server_errors_warn         = try(azurerm_monitor_metric_alert.server_errors_warn[0].name, null)
    server_errors_crit         = try(azurerm_monitor_metric_alert.server_errors_crit[0].name, null)
    size_warn                  = try(azurerm_monitor_metric_alert.size_warn[0].name, null)
    size_crit                  = try(azurerm_monitor_metric_alert.size_crit[0].name, null)
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
