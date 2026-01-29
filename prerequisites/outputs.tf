output "resource_group_name" {
  description = "Name of the monitoring resource group"
  value       = azurerm_resource_group.monitoring.name
}

output "resource_group_id" {
  description = "ID of the monitoring resource group"
  value       = azurerm_resource_group.monitoring.id
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.monitoring.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.monitoring.name
}

output "action_group_critical_id" {
  description = "ID of the critical severity action group"
  value       = azurerm_monitor_action_group.critical.id
}

output "action_group_warning_id" {
  description = "ID of the warning severity action group"
  value       = azurerm_monitor_action_group.warning.id
}

output "action_group_ids" {
  description = "Map of action group IDs for use in monitoring modules"
  value = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
