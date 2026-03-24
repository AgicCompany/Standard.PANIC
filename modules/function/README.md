# terraform-azurerm-monitor-function

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Functions monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- HTTP error monitoring (5xx and 4xx)
- Response time tracking
- Memory usage monitoring
- Function execution count alerts
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| HTTP 5xx | Server errors | > 5 | > 20 | > 1 | > 10 |
| HTTP 4xx | Client errors (disabled) | > 50 | > 200 | > 25 | > 100 |
| Response Time | Avg response time | > 5s | > 10s | > 2s | > 5s |
| Memory | Memory working set | > 80% | > 95% | > 70% | > 90% |
| Execution Count | Function runs (disabled) | > 10000 | > 50000 | > 10000 | > 50000 |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "function_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/function?ref=function/v1.0.0"

  resource_id         = azurerm_linux_function_app.main.id
  resource_name       = "app-functions"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Memory Threshold

```hcl
module "function_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/function?ref=function/v1.0.0"

  resource_id         = azurerm_linux_function_app.main.id
  resource_name       = "prod-functions"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    memory = {
      # Premium plan with 3.5GB memory limit
      warning_threshold  = 2867000000  # ~2.67GB (80%)
      critical_threshold = 3328000000  # ~3.1GB (90%)
    }
    response_time = {
      warning_threshold  = 1
      critical_threshold = 3
    }
  }
}
```

### Enable 4xx Monitoring

```hcl
module "function_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/function?ref=function/v1.0.0"

  resource_id         = azurerm_linux_function_app.main.id
  resource_name       = "api-functions"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    http_4xx = {
      enabled            = true
      warning_threshold  = 100
      critical_threshold = 500
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
| resource_id | Resource ID of the Function App to monitor | `string` | n/a | yes |
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

- **Memory thresholds**: Default profile values are percentages. Override with actual byte values based on your plan's memory limit.
- **HTTP 4xx**: Disabled by default as these often represent expected client errors (auth failures, not found, etc.).
- **Execution count**: Useful for detecting unexpected spikes or drops in function invocations.
- **Consumption plan**: Memory metrics may be less meaningful on consumption plans due to dynamic scaling.

## Memory Limits by Plan

| Plan | Memory Limit |
|------|--------------|
| Consumption | 1.5 GB |
| Premium EP1 | 3.5 GB |
| Premium EP2 | 7 GB |
| Premium EP3 | 14 GB |
| Dedicated (Basic) | 1.75 GB |
| Dedicated (Standard) | 3.5 GB |

## License

MIT
