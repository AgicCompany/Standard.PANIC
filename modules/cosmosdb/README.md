# terraform-azurerm-monitor-cosmosdb

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Cosmos DB monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- RU consumption monitoring (normalized)
- Service availability tracking
- Server-side latency monitoring
- Throttled request (429) detection
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| RU Consumption | Normalized RU % | > 70% | > 90% | > 60% | > 80% |
| Availability | Service availability | < 99.9% | < 99% | < 99.95% | < 99.5% |
| Server Latency | Server-side latency | > 50ms | > 100ms | > 30ms | > 75ms |
| Throttled Requests | 429 status count | > 10 | > 50 | > 5 | > 25 |
| Total Requests | Request count (disabled) | > 10000 | > 50000 | > 10000 | > 50000 |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "cosmosdb_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/cosmosdb?ref=cosmosdb/v1.0.0"

  resource_id         = azurerm_cosmosdb_account.main.id
  resource_name       = "app-cosmos"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Custom Thresholds

```hcl
module "cosmosdb_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/cosmosdb?ref=cosmosdb/v1.0.0"

  resource_id         = azurerm_cosmosdb_account.main.id
  resource_name       = "prod-cosmos"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    ru_consumption = {
      warning_threshold  = 50
      critical_threshold = 70
    }
    server_latency = {
      warning_threshold  = 20
      critical_threshold = 50
    }
  }
}
```

### Enable Request Volume Monitoring

```hcl
module "cosmosdb_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/cosmosdb?ref=cosmosdb/v1.0.0"

  resource_id         = azurerm_cosmosdb_account.main.id
  resource_name       = "monitored-cosmos"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    total_requests = {
      enabled            = true
      warning_threshold  = 5000   # Adjust based on baseline
      critical_threshold = 10000
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_id | Resource ID of the Cosmos DB account to monitor | `string` | n/a | yes |
| resource_name | Display name for the alerts (used in alert naming) | `string` | n/a | yes |
| resource_group_name | Resource group where the alerts will be created | `string` | n/a | yes |
| action_group_ids | Map of action group IDs for alert notifications | `object` | n/a | yes |
| profile | Alert profile to use (standard or critical) | `string` | `"standard"` | no |
| overrides | Optional overrides for specific metrics | `object` | `{}` | no |
| enabled | Enable or disable all alerts | `bool` | `true` | no |
| tags | Additional tags to apply to all alerts | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alert_ids | Map of created alert rule IDs |
| alert_names | Map of created alert rule names |
| profile | The alert profile used |
| resolved_thresholds | Final threshold values after applying overrides |

## Notes

- **Normalized RU Consumption**: This is the most critical metric. Values approaching 100% indicate you need to scale up or optimize queries.
- **Throttled Requests (429)**: These indicate RU exhaustion. Even a few 429s can impact user experience.
- **Server-Side Latency**: Excludes network latency. High values may indicate hot partitions or complex queries.
- **Total Requests**: Disabled by default. Enable for baseline monitoring and anomaly detection.

## Cosmos DB Considerations

- **Autoscale**: If using autoscale, RU consumption thresholds may need adjustment as the baseline changes.
- **Multi-region**: Alerts apply to the account level. Consider per-region monitoring for geo-distributed workloads.
- **Partition key**: Hot partitions can cause localized throttling not visible in account-level metrics.

## License

MIT
