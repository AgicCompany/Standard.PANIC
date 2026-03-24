# terraform-azurerm-monitor-lb

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Load Balancer monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Health probe and data path availability monitoring
- SNAT exhaustion monitoring
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| Health Probe Status | Backend pool health | - | < 100% | - | < 100% |
| Data Path Availability | LB data path availability | < 99.9% | < 99% | < 99.95% | < 99.5% |
| SNAT Connection Count | SNAT connections (% of limit) | > 80% | > 95% | > 70% | > 90% |
| Used SNAT Ports | SNAT port utilization | > 80% | > 95% | > 70% | > 90% |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "lb_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/lb?ref=lb/v1.0.0"

  resource_id         = azurerm_lb.main.id
  resource_name       = "myapp-lb"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Overrides

```hcl
module "lb_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/lb?ref=lb/v1.0.0"

  resource_id         = azurerm_lb.production.id
  resource_name       = "production-lb"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    snat_connection_count = {
      warning_threshold  = 60
      critical_threshold = 80
    }
    used_snat_ports = {
      enabled = false  # Disable if not using outbound SNAT
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
| resource_id | Resource ID of the Load Balancer to monitor | `string` | n/a | yes |
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

- **Health Probe Status** only has a critical alert (no warning level) as it indicates backend health.
- **SNAT metrics** are most relevant for outbound connectivity scenarios. Disable if using NAT Gateway or other outbound solutions.
- For Standard Load Balancer, all metrics are available. Basic Load Balancer has limited metrics.

## License

MIT
