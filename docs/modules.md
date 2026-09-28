---
title: Modules
date: 2026-09-28
status: draft
version: 0.1
---

# Modules

PANIC has 22 resource modules and one generic `base` module. All resource modules share the same inputs and outputs, described in [Concepts](concepts.md#common-inputs-and-outputs).

Source URL pattern:

```
git::https://github.com/AgicCompany/Standard.PANIC.git//modules/<module>?ref=<module>/v<version>
```

See [Versioning](versioning.md) for how to pick the version.

## Resource modules

"Metrics on" counts the metrics enabled by default in the `standard` profile, out of all metrics the module knows. Turn the rest on with [overrides](concepts.md#overrides).

| Resource | Module | Azure resource type | Metrics on | Details |
|----------|--------|---------------------|------------|---------|
| AKS | [`aks`](../modules/aks/) | `Microsoft.ContainerService/managedClusters` | 4 of 5 | [thresholds](thresholds.md#aks-aks) |
| App Service | [`appservice`](../modules/appservice/) | `Microsoft.Web/sites` | 3 of 5 | [thresholds](thresholds.md#app-service-appservice) |
| Application Gateway | [`appgateway`](../modules/appgateway/) | `Microsoft.Network/applicationGateways` | 5 of 6 | [thresholds](thresholds.md#application-gateway-appgateway) |
| Azure Firewall | [`firewall`](../modules/firewall/) | `Microsoft.Network/azureFirewalls` | 4 of 4 | [thresholds](thresholds.md#azure-firewall-firewall) |
| Azure SQL Database | [`sqldb`](../modules/sqldb/) | `Microsoft.Sql/servers/databases` | 7 of 7 | [thresholds](thresholds.md#azure-sql-database-sqldb) |
| Container App | [`containerapp`](../modules/containerapp/) | `Microsoft.App/containerApps` | 3 of 5 | [thresholds](thresholds.md#container-app-containerapp) |
| Cosmos DB | [`cosmosdb`](../modules/cosmosdb/) | `Microsoft.DocumentDB/databaseAccounts` | 4 of 5 | [thresholds](thresholds.md#cosmos-db-cosmosdb) |
| Event Hub Namespace | [`eventhub`](../modules/eventhub/) | `Microsoft.EventHub/namespaces` | 3 of 5 | [thresholds](thresholds.md#event-hub-namespace-eventhub) |
| ExpressRoute Circuit | [`expressroute`](../modules/expressroute/) | `Microsoft.Network/expressRouteCircuits` | 6 of 6 | [thresholds](thresholds.md#expressroute-circuit-expressroute) |
| Function App | [`function`](../modules/function/) | `Microsoft.Web/sites` | 3 of 5 | [thresholds](thresholds.md#function-app-function) |
| Key Vault | [`keyvault`](../modules/keyvault/) | `Microsoft.KeyVault/vaults` | 3 of 4 | [thresholds](thresholds.md#key-vault-keyvault) |
| Load Balancer | [`lb`](../modules/lb/) | `Microsoft.Network/loadBalancers` | 4 of 4 | [thresholds](thresholds.md#load-balancer-lb) |
| Managed Disk | [`disk`](../modules/disk/) | `Microsoft.Compute/disks` | 3 of 5 | [thresholds](thresholds.md#managed-disk-disk) |
| MySQL Flexible Server | [`mysql`](../modules/mysql/) | `Microsoft.DBforMySQL/flexibleServers` | 6 of 7 | [thresholds](thresholds.md#mysql-flexible-server-mysql) |
| PostgreSQL Flexible Server | [`postgresql`](../modules/postgresql/) | `Microsoft.DBforPostgreSQL/flexibleServers` | 6 of 7 | [thresholds](thresholds.md#postgresql-flexible-server-postgresql) |
| Redis Cache | [`redis`](../modules/redis/) | `Microsoft.Cache/redis` | 4 of 5 | [thresholds](thresholds.md#redis-cache-redis) |
| Service Bus Namespace | [`servicebus`](../modules/servicebus/) | `Microsoft.ServiceBus/namespaces` | 5 of 5 | [thresholds](thresholds.md#service-bus-namespace-servicebus) |
| SQL Managed Instance | [`sqlmi`](../modules/sqlmi/) | `Microsoft.Sql/managedInstances` | 4 of 4 | [thresholds](thresholds.md#sql-managed-instance-sqlmi) |
| Storage Account | [`storage`](../modules/storage/) | `Microsoft.Storage/storageAccounts` | 4 of 4 | [thresholds](thresholds.md#storage-account-storage) |
| Virtual Machine | [`vm`](../modules/vm/) | `Microsoft.Compute/virtualMachines` | 4 of 6 | [thresholds](thresholds.md#virtual-machine-vm) |
| Virtual Machine Scale Set | [`vmss`](../modules/vmss/) | `Microsoft.Compute/virtualMachineScaleSets` | 5 of 5 | [thresholds](thresholds.md#virtual-machine-scale-set-vmss) |
| VPN Gateway | [`vpngw`](../modules/vpngw/) | `Microsoft.Network/virtualNetworkGateways` | 3 of 5 | [thresholds](thresholds.md#vpn-gateway-vpngw) |

## Base module

[`base`](../modules/base/) creates a single metric alert from raw inputs: `metric_namespace`, `metric_name`, `operator`, `threshold`, `severity`, `action_group_id`, and optional `dimensions`. It has no profiles or overrides. Use it for a metric that no resource module covers.

```hcl
module "custom_alert" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/base?ref=base/v1.0.0"

  name                = "myapp-vm01-network-in-warn"
  resource_group_name = "rg-monitoring-prod"
  resource_id         = azurerm_linux_virtual_machine.app.id
  metric_namespace    = "Microsoft.Compute/virtualMachines"
  metric_name         = "Network In Total"
  aggregation         = "Total"
  operator            = "GreaterThan"
  threshold           = 50000000000
  severity            = 2
  action_group_id     = azurerm_monitor_action_group.warning.id
}
```

## Module docs and examples

Each resource module folder has a README with its inputs, and two runnable examples:

- `examples/standard/`: the module with default settings.
- `examples/critical-with-overrides/`: the `critical` profile with some overrides.
