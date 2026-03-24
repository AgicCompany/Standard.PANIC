# terraform-azurerm-monitor-appgateway

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Application Gateway monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Comprehensive Application Gateway metrics coverage
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| Unhealthy Hosts | Number of unhealthy backend hosts | >= 1 | >= 2 | >= 1 | >= 1 |
| Backend 5xx | Backend HTTP 5xx response count | > 10 | > 50 | > 5 | > 25 |
| CPU | CPU utilization percentage | > 80% | > 95% | > 70% | > 90% |
| Capacity Units | Capacity units consumed | > 70 | > 90 | > 60 | > 80 |
| Failed Requests | Count of failed requests | > 50 | > 200 | > 25 | > 100 |
| Response 5xx | HTTP 5xx response from gateway | > 10 | > 50 | > 5 | > 25 |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "appgateway_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/appgateway?ref=appgateway/v1.0.0"

  resource_id         = azurerm_application_gateway.main.id
  resource_name       = "myapp-appgw"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Overrides

```hcl
module "appgateway_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/appgateway?ref=appgateway/v1.0.0"

  resource_id         = azurerm_application_gateway.main.id
  resource_name       = "production-appgw"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    capacity_units = {
      warning_threshold  = 50
      critical_threshold = 75
    }
    backend_5xx = {
      enabled = false  # Disable if using custom error handling
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
| resource_id | Resource ID of the Application Gateway to monitor | `string` | n/a | yes |
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

## License

MIT
