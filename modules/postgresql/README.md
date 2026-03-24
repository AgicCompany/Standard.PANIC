# terraform-azurerm-monitor-postgresql

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for creating Azure Monitor metric alerts for PostgreSQL Flexible Server.

## Overview

This module creates a comprehensive set of metric alerts for Azure PostgreSQL Flexible Server using a profile-based approach. It supports two profiles (standard and critical) with predefined thresholds, and allows metric-specific overrides.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Default |
|--------|-------------|---------------|---------------|---------------|---------------|---------|
| CPU % | CPU utilization | > 80 | > 95 | > 70 | > 90 | Enabled |
| Memory % | Memory utilization | > 80 | > 95 | > 70 | > 90 | Enabled |
| Storage % | Storage utilization | > 80 | > 90 | > 70 | > 85 | Enabled |
| Active Connections | Connection count | > 80 | > 90 | > 70 | > 85 | Enabled |
| Failed Connections | Failed connection count | > 10 | > 50 | > 5 | > 25 | Enabled |
| Is DB Alive | Database availability | - | < 1 | - | < 1 | Enabled |
| Replication Lag | Replication delay (sec)* | > 30 | > 60 | > 10 | > 30 | Disabled |

*Replication lag is only applicable for read replicas and is disabled by default.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_id | Resource ID of the PostgreSQL Flexible Server | `string` | n/a | yes |
| resource_name | Display name for alerts | `string` | n/a | yes |
| resource_group_name | Resource group for alerts | `string` | n/a | yes |
| action_group_ids | Map with critical/warning action group IDs | `object` | n/a | yes |
| profile | Alert profile (standard or critical) | `string` | `"standard"` | no |
| overrides | Metric-specific threshold overrides | `object` | `{}` | no |
| enabled | Enable/disable all alerts | `bool` | `true` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alert_ids | Map of created alert rule IDs |
| alert_names | Map of created alert rule names |
| profile | The alert profile used |
| resolved_thresholds | Final threshold values after overrides |

## Usage

### Standard Profile

```hcl
module "postgresql_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/postgresql?ref=postgresql/v1.0.0"

  resource_id         = azurerm_postgresql_flexible_server.example.id
  resource_name       = "dev-postgres-01"
  resource_group_name = "rg-monitoring-dev"
  profile             = "standard"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Overrides

```hcl
module "postgresql_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/postgresql?ref=postgresql/v1.0.0"

  resource_id         = azurerm_postgresql_flexible_server.production.id
  resource_name       = "prod-postgres-01"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.prod_critical.id
    warning  = azurerm_monitor_action_group.prod_warning.id
  }

  overrides = {
    cpu = {
      warning_threshold  = 60
      critical_threshold = 80
    }
    storage = {
      warning_threshold  = 60
      critical_threshold = 75
    }
    # Enable replication lag for read replicas
    replication_lag = {
      enabled = true
    }
  }
}
```

## Alert Naming

Alerts follow the naming convention: `{resource_name}-{metric}-{level}`

Examples:
- `dev-postgres-01-cpu-warn`
- `dev-postgres-01-cpu-crit`
- `prod-postgres-01-availability-crit`

## License

MIT
