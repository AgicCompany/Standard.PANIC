# terraform-azurerm-monitor-appservice

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for creating Azure Monitor metric alerts for App Services.

## Overview

This module creates a comprehensive set of metric alerts for Azure App Services using a profile-based approach. It supports two profiles (standard and critical) with predefined thresholds, and allows metric-specific overrides.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Default |
|--------|-------------|---------------|---------------|---------------|---------------|---------|
| HTTP 5xx | Server error count | > 10 | > 50 | > 5 | > 25 | Enabled |
| Response Time | Avg response time (ms) | > 2000 | > 5000 | > 1000 | > 3000 | Enabled |
| Health Check | Health status | - | < 1 | - | < 1 | Enabled |
| CPU Time | CPU time (seconds)* | > 300 | > 600 | > 200 | > 400 | Disabled |
| Memory | Working set (bytes)* | > 1GB | > 1.5GB | > 512MB | > 1GB | Disabled |

*CPU and Memory metrics at the app level use CpuTime and AverageMemoryWorkingSet. For percentage-based monitoring, use App Service Plan level metrics. These are disabled by default as thresholds are workload-dependent.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_id | Resource ID of the App Service | `string` | n/a | yes |
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
module "appservice_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/appservice?ref=appservice/v1.0.0"

  resource_id         = azurerm_linux_web_app.example.id
  resource_name       = "dev-webapp-01"
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
module "appservice_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/appservice?ref=appservice/v1.0.0"

  resource_id         = azurerm_linux_web_app.production.id
  resource_name       = "prod-api"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.prod_critical.id
    warning  = azurerm_monitor_action_group.prod_warning.id
  }

  overrides = {
    response_time = {
      warning_threshold  = 500
      critical_threshold = 1000
    }
    http_5xx = {
      warning_threshold  = 1
      critical_threshold = 5
    }
  }
}
```

## Alert Naming

Alerts follow the naming convention: `{resource_name}-{metric}-{level}`

Examples:
- `dev-webapp-01-cpu-warn`
- `dev-webapp-01-cpu-crit`
- `dev-webapp-01-health-crit`

## License

MIT
