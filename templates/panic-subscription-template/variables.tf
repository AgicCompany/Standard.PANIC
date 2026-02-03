# =============================================================================
# Shared Configuration
# =============================================================================

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for alert rules"
  type        = string
}

variable "action_group_ids" {
  description = "Map with 'critical' and 'warning' action group IDs"
  type        = map(string)
}

variable "default_profile" {
  description = "Default profile for resources that do not specify one"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "critical"], var.default_profile)
    error_message = "Profile must be 'standard' or 'critical'."
  }
}

variable "tags" {
  description = "Additional tags for alert rules"
  type        = map(string)
  default     = {}
}

# =============================================================================
# Feature Switches
# =============================================================================

variable "enable_vm_alerts" {
  description = "Enable Virtual Machine alerts"
  type        = bool
  default     = false
}

variable "enable_storage_alerts" {
  description = "Enable Storage Account alerts"
  type        = bool
  default     = false
}

variable "enable_postgresql_alerts" {
  description = "Enable PostgreSQL Flexible Server alerts"
  type        = bool
  default     = false
}

variable "enable_appservice_alerts" {
  description = "Enable App Service alerts"
  type        = bool
  default     = false
}

variable "enable_appgateway_alerts" {
  description = "Enable Application Gateway alerts"
  type        = bool
  default     = false
}

variable "enable_vmss_alerts" {
  description = "Enable Virtual Machine Scale Set alerts"
  type        = bool
  default     = false
}

variable "enable_disk_alerts" {
  description = "Enable Managed Disk alerts"
  type        = bool
  default     = false
}

variable "enable_lb_alerts" {
  description = "Enable Load Balancer alerts"
  type        = bool
  default     = false
}

variable "enable_vpngw_alerts" {
  description = "Enable VPN Gateway alerts"
  type        = bool
  default     = false
}

variable "enable_expressroute_alerts" {
  description = "Enable ExpressRoute Circuit alerts"
  type        = bool
  default     = false
}

variable "enable_firewall_alerts" {
  description = "Enable Azure Firewall alerts"
  type        = bool
  default     = false
}

variable "enable_sqldb_alerts" {
  description = "Enable Azure SQL Database alerts"
  type        = bool
  default     = false
}

variable "enable_sqlmi_alerts" {
  description = "Enable SQL Managed Instance alerts"
  type        = bool
  default     = false
}

variable "enable_mysql_alerts" {
  description = "Enable MySQL Flexible Server alerts"
  type        = bool
  default     = false
}

variable "enable_cosmosdb_alerts" {
  description = "Enable Cosmos DB alerts"
  type        = bool
  default     = false
}

variable "enable_function_alerts" {
  description = "Enable Function App alerts"
  type        = bool
  default     = false
}

variable "enable_keyvault_alerts" {
  description = "Enable Key Vault alerts"
  type        = bool
  default     = false
}

variable "enable_servicebus_alerts" {
  description = "Enable Service Bus alerts"
  type        = bool
  default     = false
}

variable "enable_eventhub_alerts" {
  description = "Enable Event Hub alerts"
  type        = bool
  default     = false
}

variable "enable_aks_alerts" {
  description = "Enable AKS alerts"
  type        = bool
  default     = false
}

variable "enable_containerapp_alerts" {
  description = "Enable Container App alerts"
  type        = bool
  default     = false
}

variable "enable_redis_alerts" {
  description = "Enable Redis Cache alerts"
  type        = bool
  default     = false
}

# =============================================================================
# Resource Inventory Variables
# =============================================================================

variable "vms" {
  description = "Virtual Machines to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "storage_accounts" {
  description = "Storage Accounts to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "postgresql_servers" {
  description = "PostgreSQL Flexible Servers to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "app_services" {
  description = "App Services to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "app_gateways" {
  description = "Application Gateways to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "vmss" {
  description = "Virtual Machine Scale Sets to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "managed_disks" {
  description = "Managed Disks to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "load_balancers" {
  description = "Load Balancers to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "vpn_gateways" {
  description = "VPN Gateways to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "expressroute_circuits" {
  description = "ExpressRoute Circuits to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "firewalls" {
  description = "Azure Firewalls to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "sql_databases" {
  description = "Azure SQL Databases to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "sql_managed_instances" {
  description = "SQL Managed Instances to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "mysql_servers" {
  description = "MySQL Flexible Servers to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "cosmosdb_accounts" {
  description = "Cosmos DB Accounts to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "function_apps" {
  description = "Function Apps to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "key_vaults" {
  description = "Key Vaults to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "service_bus_namespaces" {
  description = "Service Bus Namespaces to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "event_hubs" {
  description = "Event Hubs to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "aks_clusters" {
  description = "AKS Clusters to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "container_apps" {
  description = "Container Apps to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}

variable "redis_caches" {
  description = "Redis Caches to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}
