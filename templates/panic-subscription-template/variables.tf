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
    overrides = optional(object({
      cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      memory = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      os_disk_iops = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      data_disk_iops = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      disk_free = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      availability = optional(object({
        enabled            = optional(bool)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "storage_accounts" {
  description = "Storage Accounts to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      availability = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      latency = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      throttling = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      used_capacity = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "postgresql_servers" {
  description = "PostgreSQL Flexible Servers to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      memory = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      storage = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      connections = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      failed_connections = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      availability = optional(object({
        enabled            = optional(bool)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      replication_lag = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "app_services" {
  description = "App Services to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      memory = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      http_5xx = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      response_time = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      health_check = optional(object({
        enabled            = optional(bool)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "app_gateways" {
  description = "Application Gateways to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      unhealthy_hosts = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      backend_5xx = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      capacity_units = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      failed_requests = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      response_5xx = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "vmss" {
  description = "Virtual Machine Scale Sets to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      memory = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      os_disk_iops = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      data_disk_iops = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      availability = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "managed_disks" {
  description = "Managed Disks to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      iops_consumed = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      bandwidth_consumed = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      queue_depth = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      burst_bps_credits = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      burst_io_credits = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "load_balancers" {
  description = "Load Balancers to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      health_probe_status = optional(object({
        enabled            = optional(bool)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      data_path_availability = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      snat_connection_count = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      used_snat_ports = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "vpn_gateways" {
  description = "VPN Gateways to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      tunnel_status = optional(object({
        enabled            = optional(bool)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      tunnel_bandwidth = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      p2s_bandwidth = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      p2s_connection_count = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      tunnel_drop_count = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "expressroute_circuits" {
  description = "ExpressRoute Circuits to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      bgp_availability = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      arp_availability = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      bits_in = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      bits_out = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      dropped_packets_in = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      dropped_packets_out = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "firewalls" {
  description = "Azure Firewalls to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      health_state = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      throughput = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      snat_port_utilization = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      latency = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "sql_databases" {
  description = "Azure SQL Databases to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      dtu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      storage = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      deadlocks = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      connection_failed = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      sessions = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      workers = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "sql_managed_instances" {
  description = "SQL Managed Instances to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      storage = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      io_requests = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      io_bytes = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "mysql_servers" {
  description = "MySQL Flexible Servers to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      memory = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      storage = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      io = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      connections = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      aborted_connections = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      replication_lag = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "cosmosdb_accounts" {
  description = "Cosmos DB Accounts to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      ru_consumption = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      availability = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      server_latency = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      throttled_requests = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      total_requests = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "function_apps" {
  description = "Function Apps to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      http_5xx = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      http_4xx = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      response_time = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      memory = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      execution_count = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "key_vaults" {
  description = "Key Vaults to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      availability = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      latency = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      saturation = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      api_hits = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "service_bus_namespaces" {
  description = "Service Bus Namespaces to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      active_messages = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      deadlettered_messages = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      throttled_requests = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      server_errors = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      size = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "event_hubs" {
  description = "Event Hubs to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      throttled_requests = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      quota_exceeded = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      server_errors = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      incoming_messages = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      capture_backlog = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "aks_clusters" {
  description = "AKS Clusters to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      node_cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      node_memory = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      node_disk = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      pod_ready = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      node_count = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "container_apps" {
  description = "Container Apps to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      memory = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      restarts = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      replicas = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      requests = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}

variable "redis_caches" {
  description = "Redis Caches to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      server_load = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      memory = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      connected_clients = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      cache_miss_rate = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      evicted_keys = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
    }))
  }))
  default = {}
}
