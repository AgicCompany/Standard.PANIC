# Available Modules

PANIC provides 22 monitoring modules: 21 resource-specific modules plus a shared base module.

## Module List

| Resource Type | Module Path |
|---------------|-------------|
| Base (core) | [modules/base](../modules/base) |
| Virtual Machines | [modules/vm](../modules/vm) |
| PostgreSQL Flexible Server | [modules/postgresql](../modules/postgresql) |
| Storage Account | [modules/storage](../modules/storage) |
| App Service | [modules/appservice](../modules/appservice) |
| Application Gateway | [modules/appgateway](../modules/appgateway) |
| AKS | [modules/aks](../modules/aks) |
| Container App | [modules/containerapp](../modules/containerapp) |
| Cosmos DB | [modules/cosmosdb](../modules/cosmosdb) |
| Managed Disks | [modules/disk](../modules/disk) |
| Event Hub | [modules/eventhub](../modules/eventhub) |
| ExpressRoute | [modules/expressroute](../modules/expressroute) |
| Azure Firewall | [modules/firewall](../modules/firewall) |
| Function App | [modules/function](../modules/function) |
| Key Vault | [modules/keyvault](../modules/keyvault) |
| Load Balancer | [modules/lb](../modules/lb) |
| MySQL Flexible Server | [modules/mysql](../modules/mysql) |
| Redis Cache | [modules/redis](../modules/redis) |
| Service Bus | [modules/servicebus](../modules/servicebus) |
| Azure SQL Database | [modules/sqldb](../modules/sqldb) |
| SQL Managed Instance | [modules/sqlmi](../modules/sqlmi) |
| VPN Gateway | [modules/vpngw](../modules/vpngw) |

## Usage

Reference modules using Git source with version tags:

```hcl
module "vm_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vm?ref=vm/v1.0.0"

  resource_id      = azurerm_virtual_machine.example.id
  resource_name    = "myapp-vm01"
  profile          = "standard"
  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

## Common Inputs

All modules accept these standard inputs:

| Input | Type | Required | Description |
|-------|------|----------|-------------|
| resource_id | string | Yes | Azure resource ID to monitor |
| resource_name | string | Yes | Name used in alert rule naming |
| profile | string | Yes | Profile to use: `standard` or `critical` |
| action_group_ids | map | Yes | Map with `critical` and `warning` action group IDs |
| overrides | map | No | Metric-specific threshold overrides |

## Module Structure

Each module follows a consistent structure:

```
modules/{resource}/
├── main.tf           # Primary configuration
├── variables.tf      # Input variables
├── outputs.tf        # Module outputs
├── profiles.tf       # Profile definitions
├── defaults.tf       # Alert defaults
├── versions.tf       # Provider versions
├── README.md         # Documentation
└── examples/
    ├── standard/
    └── critical-with-overrides/
```

See individual module READMEs for resource-specific metrics and thresholds.
