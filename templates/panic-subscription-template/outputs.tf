# =============================================================================
# Alert Rule Outputs - Grouped by Resource Type
# =============================================================================

output "vm_alert_ids" {
  description = "Alert rule IDs for Virtual Machines"
  value       = { for k, v in module.vm_alerts : k => v.alert_ids }
}

output "storage_account_alert_ids" {
  description = "Alert rule IDs for Storage Accounts"
  value       = { for k, v in module.storage_account_alerts : k => v.alert_ids }
}

output "postgresql_server_alert_ids" {
  description = "Alert rule IDs for PostgreSQL Flexible Servers"
  value       = { for k, v in module.postgresql_server_alerts : k => v.alert_ids }
}

output "app_service_alert_ids" {
  description = "Alert rule IDs for App Services"
  value       = { for k, v in module.app_service_alerts : k => v.alert_ids }
}

output "app_gateway_alert_ids" {
  description = "Alert rule IDs for Application Gateways"
  value       = { for k, v in module.app_gateway_alerts : k => v.alert_ids }
}

output "vmss_alert_ids" {
  description = "Alert rule IDs for Virtual Machine Scale Sets"
  value       = { for k, v in module.vmss_alerts : k => v.alert_ids }
}

output "managed_disk_alert_ids" {
  description = "Alert rule IDs for Managed Disks"
  value       = { for k, v in module.managed_disk_alerts : k => v.alert_ids }
}

output "load_balancer_alert_ids" {
  description = "Alert rule IDs for Load Balancers"
  value       = { for k, v in module.load_balancer_alerts : k => v.alert_ids }
}

output "vpn_gateway_alert_ids" {
  description = "Alert rule IDs for VPN Gateways"
  value       = { for k, v in module.vpn_gateway_alerts : k => v.alert_ids }
}

output "expressroute_circuit_alert_ids" {
  description = "Alert rule IDs for ExpressRoute Circuits"
  value       = { for k, v in module.expressroute_circuit_alerts : k => v.alert_ids }
}

output "firewall_alert_ids" {
  description = "Alert rule IDs for Azure Firewalls"
  value       = { for k, v in module.firewall_alerts : k => v.alert_ids }
}

output "sql_database_alert_ids" {
  description = "Alert rule IDs for Azure SQL Databases"
  value       = { for k, v in module.sql_database_alerts : k => v.alert_ids }
}

output "sql_managed_instance_alert_ids" {
  description = "Alert rule IDs for SQL Managed Instances"
  value       = { for k, v in module.sql_managed_instance_alerts : k => v.alert_ids }
}

output "mysql_server_alert_ids" {
  description = "Alert rule IDs for MySQL Flexible Servers"
  value       = { for k, v in module.mysql_server_alerts : k => v.alert_ids }
}

output "cosmosdb_account_alert_ids" {
  description = "Alert rule IDs for Cosmos DB Accounts"
  value       = { for k, v in module.cosmosdb_account_alerts : k => v.alert_ids }
}

output "function_app_alert_ids" {
  description = "Alert rule IDs for Function Apps"
  value       = { for k, v in module.function_app_alerts : k => v.alert_ids }
}

output "key_vault_alert_ids" {
  description = "Alert rule IDs for Key Vaults"
  value       = { for k, v in module.key_vault_alerts : k => v.alert_ids }
}

output "service_bus_namespace_alert_ids" {
  description = "Alert rule IDs for Service Bus Namespaces"
  value       = { for k, v in module.service_bus_namespace_alerts : k => v.alert_ids }
}

output "event_hub_alert_ids" {
  description = "Alert rule IDs for Event Hubs"
  value       = { for k, v in module.event_hub_alerts : k => v.alert_ids }
}

output "aks_cluster_alert_ids" {
  description = "Alert rule IDs for AKS Clusters"
  value       = { for k, v in module.aks_cluster_alerts : k => v.alert_ids }
}

output "container_app_alert_ids" {
  description = "Alert rule IDs for Container Apps"
  value       = { for k, v in module.container_app_alerts : k => v.alert_ids }
}

output "redis_cache_alert_ids" {
  description = "Alert rule IDs for Redis Caches"
  value       = { for k, v in module.redis_cache_alerts : k => v.alert_ids }
}
