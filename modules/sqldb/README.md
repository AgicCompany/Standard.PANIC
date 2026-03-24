# terraform-azurerm-monitor-sqldb

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure SQL Database monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- CPU and DTU consumption monitoring
- Storage capacity alerts
- Deadlock detection
- Failed connection tracking
- Session and worker utilization monitoring
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| CPU % | CPU utilization | > 80% | > 95% | > 70% | > 90% |
| DTU % | DTU consumption | > 80% | > 95% | > 70% | > 90% |
| Storage % | Data space used | > 80% | > 90% | > 70% | > 85% |
| Deadlocks | Deadlock count | > 5 | > 20 | > 2 | > 10 |
| Failed Connections | Connection failures | > 10 | > 50 | > 5 | > 25 |
| Sessions % | Session utilization | > 80% | > 95% | > 70% | > 90% |
| Workers % | Worker utilization | > 80% | > 95% | > 70% | > 90% |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "sqldb_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/sqldb?ref=sqldb-v1.0.0"

  resource_id         = azurerm_mssql_database.main.id
  resource_name       = "app-database"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Overrides

```hcl
module "sqldb_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/sqldb?ref=sqldb-v1.0.0"

  resource_id         = azurerm_mssql_database.main.id
  resource_name       = "prod-database"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    cpu = {
      warning_threshold  = 60
      critical_threshold = 80
    }
    dtu = {
      enabled = false  # Disable for vCore-based databases
    }
    storage = {
      warning_threshold  = 75
      critical_threshold = 85
      window_minutes     = 30
    }
  }
}
```

### vCore-based Database (Disable DTU)

```hcl
module "sqldb_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/sqldb?ref=sqldb-v1.0.0"

  resource_id         = azurerm_mssql_database.main.id
  resource_name       = "vcore-database"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    dtu = {
      enabled = false  # DTU metrics not available for vCore
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
| resource_id | Resource ID of the Azure SQL Database to monitor | `string` | n/a | yes |
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

- **DTU vs vCore**: DTU metrics are only available for DTU-based databases. Disable the DTU metric for vCore-based databases using overrides.
- **Sessions and Workers**: High utilization can cause connection errors and query timeouts. Monitor these closely for high-traffic applications.
- **Deadlocks**: Frequent deadlocks indicate application-level issues with transaction ordering.
- **Storage**: Storage alerts use a longer window (15 min) as capacity changes are gradual.

## License

MIT
