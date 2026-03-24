# terraform-azurerm-monitor-sqlmi

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure SQL Managed Instance monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- CPU utilization monitoring
- Storage space tracking
- IO operations monitoring (IOPS and throughput)
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| CPU % | Average CPU utilization | > 80% | > 95% | > 70% | > 90% |
| Storage | Storage space used (MB) | Override required | Override required | Override required | Override required |
| IO Requests | IO operations count | > 80% | > 95% | > 70% | > 90% |
| IO Bytes | IO throughput (bytes read) | > 80% | > 95% | > 70% | > 90% |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "sqlmi_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/sqlmi?ref=sqlmi-v1.0.0"

  resource_id         = azurerm_mssql_managed_instance.main.id
  resource_name       = "prod-sqlmi"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  # Storage thresholds in MB - calculate based on your reserved storage
  # Example: 256 GB reserved = 262144 MB
  overrides = {
    storage = {
      warning_threshold  = 209715  # 80% of 256 GB
      critical_threshold = 235929  # 90% of 256 GB
    }
  }
}
```

### Critical Profile with Custom Thresholds

```hcl
module "sqlmi_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/sqlmi?ref=sqlmi-v1.0.0"

  resource_id         = azurerm_mssql_managed_instance.main.id
  resource_name       = "critical-sqlmi"
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
    storage = {
      # 512 GB reserved storage
      warning_threshold  = 366001  # 70% of 512 GB
      critical_threshold = 445645  # 85% of 512 GB
    }
    io_requests = {
      enabled = false  # Disable if using premium storage
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
| resource_id | Resource ID of the SQL Managed Instance to monitor | `string` | n/a | yes |
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

- **Storage thresholds**: SQL MI reports storage in MB, not percentage. Calculate thresholds based on your reserved storage size.
- **IO metrics**: Thresholds depend on your SQL MI tier and vCore count. Adjust based on documented limits.
- **CPU**: vCore-based, monitor closely for Business Critical tier workloads.

## Storage Calculation

| Reserved Storage | 80% Warning (MB) | 90% Critical (MB) |
|------------------|------------------|-------------------|
| 32 GB | 26214 | 29491 |
| 64 GB | 52429 | 58982 |
| 128 GB | 104858 | 117965 |
| 256 GB | 209715 | 235929 |
| 512 GB | 419430 | 471859 |
| 1 TB | 838861 | 943718 |

## License

MIT
