output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    server_load_warn       = try(azurerm_monitor_metric_alert.server_load_warn[0].id, null)
    server_load_crit       = try(azurerm_monitor_metric_alert.server_load_crit[0].id, null)
    memory_warn            = try(azurerm_monitor_metric_alert.memory_warn[0].id, null)
    memory_crit            = try(azurerm_monitor_metric_alert.memory_crit[0].id, null)
    connected_clients_warn = try(azurerm_monitor_metric_alert.connected_clients_warn[0].id, null)
    connected_clients_crit = try(azurerm_monitor_metric_alert.connected_clients_crit[0].id, null)
    cache_miss_rate_warn   = try(azurerm_monitor_metric_alert.cache_miss_rate_warn[0].id, null)
    cache_miss_rate_crit   = try(azurerm_monitor_metric_alert.cache_miss_rate_crit[0].id, null)
    evicted_keys_warn      = try(azurerm_monitor_metric_alert.evicted_keys_warn[0].id, null)
    evicted_keys_crit      = try(azurerm_monitor_metric_alert.evicted_keys_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    server_load_warn       = try(azurerm_monitor_metric_alert.server_load_warn[0].name, null)
    server_load_crit       = try(azurerm_monitor_metric_alert.server_load_crit[0].name, null)
    memory_warn            = try(azurerm_monitor_metric_alert.memory_warn[0].name, null)
    memory_crit            = try(azurerm_monitor_metric_alert.memory_crit[0].name, null)
    connected_clients_warn = try(azurerm_monitor_metric_alert.connected_clients_warn[0].name, null)
    connected_clients_crit = try(azurerm_monitor_metric_alert.connected_clients_crit[0].name, null)
    cache_miss_rate_warn   = try(azurerm_monitor_metric_alert.cache_miss_rate_warn[0].name, null)
    cache_miss_rate_crit   = try(azurerm_monitor_metric_alert.cache_miss_rate_crit[0].name, null)
    evicted_keys_warn      = try(azurerm_monitor_metric_alert.evicted_keys_warn[0].name, null)
    evicted_keys_crit      = try(azurerm_monitor_metric_alert.evicted_keys_crit[0].name, null)
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
