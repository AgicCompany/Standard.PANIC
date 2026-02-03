# PANIC Subscription Template

Deploy PANIC alert rules across an Azure subscription using feature switches and inventory-based configuration.

## Overview

This template provides a standardized method for deploying Azure Monitor metric alerts using the PANIC framework. It supports all 22 PANIC resource types and uses a feature switch pattern to enable only the resource types you need.

**Key features:**
- Feature switches to enable/disable resource types
- Per-resource profile selection (standard/critical)
- Override support for metric customization
- Single state file per subscription

## Prerequisites

### Azure Resources

| Prerequisite | Description |
|--------------|-------------|
| Action Groups | Must exist before deployment. IDs passed as input. |
| Resource Group | Dedicated RG for alert rules (e.g., `rg-monitoring-prod`) |
| Monitored Resources | Resources to monitor must already exist |
| State Storage | Azure Storage Account with container for Terraform state |

### RBAC Permissions

| Scope | Role | Purpose |
|-------|------|---------|
| Alert Resource Group | Monitoring Contributor | Create/modify/delete alert rules |
| Monitored Resources | Monitoring Reader | Read metrics metadata |
| Action Groups | Reader | Reference action groups |
| State Storage Account | Storage Blob Data Contributor | Read/write state files |

### Version Requirements

- Terraform >= 1.3.0
- AzureRM Provider ~> 4.0

## Quick Start

1. **Clone the template**
   ```bash
   cp -r templates/panic-subscription-template /path/to/your/monitoring
   cd /path/to/your/monitoring
   ```

2. **Configure backend**
   ```bash
   cp backend.tf.example backend.tf
   # Edit backend.tf with your storage account details
   ```

3. **Configure variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your configuration
   ```

4. **Initialize and apply**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration Reference

### Shared Configuration

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `subscription_id` | string | Yes | Azure subscription ID |
| `resource_group_name` | string | Yes | Resource group for alert rules |
| `action_group_ids` | map(string) | Yes | Map with `critical` and `warning` action group IDs |
| `default_profile` | string | No | Default profile (`standard` or `critical`). Default: `standard` |
| `tags` | map(string) | No | Additional tags for alert rules |

### Feature Switches

| Variable | Resource Type |
|----------|---------------|
| `enable_vm_alerts` | Virtual Machines |
| `enable_storage_alerts` | Storage Accounts |
| `enable_postgresql_alerts` | PostgreSQL Flexible Server |
| `enable_appservice_alerts` | App Service |
| `enable_appgateway_alerts` | Application Gateway |
| `enable_vmss_alerts` | Virtual Machine Scale Sets |
| `enable_disk_alerts` | Managed Disks |
| `enable_lb_alerts` | Load Balancer |
| `enable_vpngw_alerts` | VPN Gateway |
| `enable_expressroute_alerts` | ExpressRoute Circuit |
| `enable_firewall_alerts` | Azure Firewall |
| `enable_sqldb_alerts` | Azure SQL Database |
| `enable_sqlmi_alerts` | SQL Managed Instance |
| `enable_mysql_alerts` | MySQL Flexible Server |
| `enable_cosmosdb_alerts` | Cosmos DB |
| `enable_function_alerts` | Function App |
| `enable_keyvault_alerts` | Key Vault |
| `enable_servicebus_alerts` | Service Bus |
| `enable_eventhub_alerts` | Event Hub |
| `enable_aks_alerts` | AKS |
| `enable_containerapp_alerts` | Container App |
| `enable_redis_alerts` | Redis Cache |

All feature switches default to `false`.

### Resource Inventory Variables

| Variable | Resource Type |
|----------|---------------|
| `vms` | Virtual Machines |
| `storage_accounts` | Storage Accounts |
| `postgresql_servers` | PostgreSQL Flexible Server |
| `app_services` | App Service |
| `app_gateways` | Application Gateway |
| `vmss` | Virtual Machine Scale Sets |
| `managed_disks` | Managed Disks |
| `load_balancers` | Load Balancer |
| `vpn_gateways` | VPN Gateway |
| `expressroute_circuits` | ExpressRoute Circuit |
| `firewalls` | Azure Firewall |
| `sql_databases` | Azure SQL Database |
| `sql_managed_instances` | SQL Managed Instance |
| `mysql_servers` | MySQL Flexible Server |
| `cosmosdb_accounts` | Cosmos DB |
| `function_apps` | Function App |
| `key_vaults` | Key Vault |
| `service_bus_namespaces` | Service Bus |
| `event_hubs` | Event Hub |
| `aks_clusters` | AKS |
| `container_apps` | Container App |
| `redis_caches` | Redis Cache |

All inventory variables default to `{}`.

### Resource Entry Structure

```hcl
"resource-name" = {
  resource_id = string           # Required: Full Azure resource ID
  profile     = optional(string) # Optional: "standard" or "critical"
  overrides   = optional(map)    # Optional: Metric-specific overrides
}
```

## Examples

### Single Resource Type

```hcl
# Enable VM alerts only
enable_vm_alerts = true

vms = {
  "myorg-dc01" = {
    resource_id = "/subscriptions/.../virtualMachines/myorg-dc01"
    profile     = "critical"
  }
}
```

### Multiple Resource Types

```hcl
# Enable multiple resource types
enable_vm_alerts      = true
enable_storage_alerts = true
enable_sqldb_alerts   = true

vms = {
  "myorg-dc01" = {
    resource_id = "/subscriptions/.../virtualMachines/myorg-dc01"
    profile     = "critical"
  }
}

storage_accounts = {
  "stproddata01" = {
    resource_id = "/subscriptions/.../storageAccounts/stproddata01"
    # Uses default_profile
  }
}

sql_databases = {
  "sqldb-app-prod" = {
    resource_id = "/subscriptions/.../databases/sqldb-app-prod"
    profile     = "critical"
  }
}
```

### With Overrides

```hcl
enable_vm_alerts = true

vms = {
  "myorg-batch01" = {
    resource_id = "/subscriptions/.../virtualMachines/myorg-batch01"
    profile     = "standard"
    overrides = {
      cpu = {
        warning_threshold  = 95
        critical_threshold = 99
      }
      memory = {
        enabled = false  # Disable memory alerts
      }
    }
  }
}
```

### Profile Inheritance

```hcl
default_profile = "standard"

vms = {
  # Inherits "standard" from default_profile
  "myorg-app01" = {
    resource_id = "/subscriptions/.../virtualMachines/myorg-app01"
  }

  # Explicitly set to "critical"
  "myorg-dc01" = {
    resource_id = "/subscriptions/.../virtualMachines/myorg-dc01"
    profile     = "critical"
  }
}
```

## Cloning Checklist

When deploying to a new subscription:

- [ ] Copy template to new location
- [ ] Copy `backend.tf.example` to `backend.tf`
- [ ] Update backend storage account and state key
- [ ] Copy `terraform.tfvars.example` to `terraform.tfvars`
- [ ] Set `subscription_id`
- [ ] Set `resource_group_name`
- [ ] Configure `action_group_ids`
- [ ] Enable required feature switches
- [ ] Populate resource inventory
- [ ] Run `terraform init`
- [ ] Run `terraform plan` and review
- [ ] Run `terraform apply`

## Lifecycle Management

### Adding Resources

1. Ensure the feature switch is enabled
2. Add entry to the appropriate inventory variable
3. Run `terraform plan` and `terraform apply`

### Removing Resources

1. Remove entry from inventory variable
2. Run `terraform plan` and `terraform apply`

### Disabling a Resource Type

1. Set feature switch to `false`
2. Run `terraform apply` (removes all alerts for that type)

## Outputs

Alert rule IDs are grouped by resource type:

- `vm_alert_ids`
- `storage_account_alert_ids`
- `postgresql_server_alert_ids`
- `app_service_alert_ids`
- `app_gateway_alert_ids`
- `vmss_alert_ids`
- `managed_disk_alert_ids`
- `load_balancer_alert_ids`
- `vpn_gateway_alert_ids`
- `expressroute_circuit_alert_ids`
- `firewall_alert_ids`
- `sql_database_alert_ids`
- `sql_managed_instance_alert_ids`
- `mysql_server_alert_ids`
- `cosmosdb_account_alert_ids`
- `function_app_alert_ids`
- `key_vault_alert_ids`
- `service_bus_namespace_alert_ids`
- `event_hub_alert_ids`
- `aks_cluster_alert_ids`
- `container_app_alert_ids`
- `redis_cache_alert_ids`

## Troubleshooting

| Error | Cause | Resolution |
|-------|-------|------------|
| `Resource not found` | Invalid resource ID | Verify resource exists |
| `Action group not found` | Invalid action group ID | Verify action group exists |
| `AuthorizationFailed` | Insufficient permissions | Check RBAC assignments |
| `Backend initialization failed` | State storage issue | Verify storage account |
| `Invalid value for variable` | Profile validation failed | Use `standard` or `critical` |

## Related Documentation

- [PANIC Framework](https://github.com/AgicCompany/Standard.PANIC)
- [Profile System](../../docs/profiles.md)
- [Architecture](../../docs/architecture.md)
- [Implementation Guide](../../docs/implementation-v2.md)
