# terraform-azurerm-monitor-mysql

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure MySQL Flexible Server monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- CPU, memory, and storage monitoring
- IO consumption tracking
- Connection monitoring (active and aborted)
- Replication lag alerts for read replicas
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| CPU % | CPU utilization | > 80% | > 95% | > 70% | > 90% |
| Memory % | Memory utilization | > 80% | > 95% | > 70% | > 90% |
| Storage % | Storage utilization | > 80% | > 90% | > 70% | > 85% |
| IO % | IO consumption | > 80% | > 95% | > 70% | > 90% |
| Active Connections | Connection count | > 80 | > 95 | > 70 | > 90 |
| Aborted Connections | Failed connections | > 10 | > 50 | > 5 | > 25 |
| Replication Lag | Lag in seconds (disabled) | > 30s | > 60s | > 15s | > 30s |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "mysql_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/mysql?ref=mysql-v1.0.0"

  resource_id         = azurerm_mysql_flexible_server.main.id
  resource_name       = "app-mysql"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Custom Connection Limits

```hcl
module "mysql_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/mysql?ref=mysql-v1.0.0"

  resource_id         = azurerm_mysql_flexible_server.main.id
  resource_name       = "prod-mysql"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    connections = {
      # Based on max_connections for your SKU
      warning_threshold  = 400  # 80% of 500 max
      critical_threshold = 475  # 95% of 500 max
    }
    cpu = {
      warning_threshold  = 60
      critical_threshold = 80
    }
  }
}
```

### Read Replica with Replication Lag Monitoring

```hcl
module "mysql_replica_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/mysql?ref=mysql-v1.0.0"

  resource_id         = azurerm_mysql_flexible_server.replica.id
  resource_name       = "mysql-replica"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    replication_lag = {
      enabled            = true
      warning_threshold  = 10
      critical_threshold = 30
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
| resource_id | Resource ID of the MySQL Flexible Server to monitor | `string` | n/a | yes |
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

- **Connection thresholds**: Default thresholds are percentages. Override with actual connection counts based on your SKU's max_connections.
- **Replication lag**: Disabled by default. Enable only for read replicas.
- **Storage auto-grow**: If enabled, storage alerts may be less critical but still useful for cost monitoring.
- **IO consumption**: High IO can indicate query performance issues or undersized storage tier.

## Max Connections by SKU

| SKU | vCores | Max Connections |
|-----|--------|-----------------|
| B1s | 1 | 341 |
| B1ms | 1 | 341 |
| B2s | 2 | 683 |
| D2ds_v4 | 2 | 683 |
| D4ds_v4 | 4 | 1365 |
| D8ds_v4 | 8 | 2731 |
| D16ds_v4 | 16 | 5461 |

## License

MIT
