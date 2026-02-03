# Available Modules

PANIC provides monitoring modules for 22 Azure resource types.

## Module List

| Resource Type | Module Repository |
|---------------|-------------------|
| Base (core) | [Standard.PANIC.terraform-azurerm-monitor-base](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-base) |
| Virtual Machines | [Standard.PANIC.terraform-azurerm-monitor-vm](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vm) |
| PostgreSQL Flexible Server | [Standard.PANIC.terraform-azurerm-monitor-postgresql](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-postgresql) |
| Storage Account | [Standard.PANIC.terraform-azurerm-monitor-storage](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-storage) |
| App Service | [Standard.PANIC.terraform-azurerm-monitor-appservice](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-appservice) |
| Application Gateway | [Standard.PANIC.terraform-azurerm-monitor-appgateway](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-appgateway) |
| AKS | [Standard.PANIC.terraform-azurerm-monitor-aks](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-aks) |
| Container App | [Standard.PANIC.terraform-azurerm-monitor-containerapp](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-containerapp) |
| Cosmos DB | [Standard.PANIC.terraform-azurerm-monitor-cosmosdb](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-cosmosdb) |
| Managed Disks | [Standard.PANIC.terraform-azurerm-monitor-disk](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-disk) |
| Event Hub | [Standard.PANIC.terraform-azurerm-monitor-eventhub](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-eventhub) |
| ExpressRoute | [Standard.PANIC.terraform-azurerm-monitor-expressroute](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-expressroute) |
| Azure Firewall | [Standard.PANIC.terraform-azurerm-monitor-firewall](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-firewall) |
| Function App | [Standard.PANIC.terraform-azurerm-monitor-function](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-function) |
| Key Vault | [Standard.PANIC.terraform-azurerm-monitor-keyvault](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-keyvault) |
| Load Balancer | [Standard.PANIC.terraform-azurerm-monitor-lb](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-lb) |
| MySQL Flexible Server | [Standard.PANIC.terraform-azurerm-monitor-mysql](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-mysql) |
| Redis Cache | [Standard.PANIC.terraform-azurerm-monitor-redis](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-redis) |
| Service Bus | [Standard.PANIC.terraform-azurerm-monitor-servicebus](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-servicebus) |
| Azure SQL Database | [Standard.PANIC.terraform-azurerm-monitor-sqldb](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-sqldb) |
| SQL Managed Instance | [Standard.PANIC.terraform-azurerm-monitor-sqlmi](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-sqlmi) |
| VPN Gateway | [Standard.PANIC.terraform-azurerm-monitor-vpngw](https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vpngw) |

## Usage

Reference modules using Git source with version tags:

```hcl
module "vm_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vm.git?ref=v1.0.0"

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
terraform-azurerm-monitor-{resource}/
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
