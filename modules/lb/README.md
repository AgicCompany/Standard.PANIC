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
| SNAT Connection Count | SNAT connection count (disabled) | Override required | Override required | Override required | Override required |
| Used SNAT Ports | Used SNAT port count (disabled) | Override required | Override required | Override required | Override required |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "lb_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/lb?ref=lb/v2.0.0"

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
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/lb?ref=lb/v2.0.0"

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
      # Example raw counts; size these for your workload.
      enabled            = true
      warning_threshold  = 1000
      critical_threshold = 2000
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
| terraform | >= 1.3 |
| azurerm | >= 4.0, < 6.0 |

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
- **SNAT metrics** are disabled by default in both profiles. `SnatConnectionCount` and `UsedSnatPorts` are Count, not percent; enable them with `enabled = true` and raw count thresholds via overrides. Profile thresholds are placeholders, not recommended limits. See [supported metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-network-loadbalancers-metrics).
- For Standard Load Balancer, all metrics are available. Basic Load Balancer has limited metrics.

## Migration (v2.0.0)

SNAT connection and used-port alerts are now disabled by default. Upgrading removes these alerts unless you explicitly enable them and set both thresholds in raw counts. A threshold-only override no longer enables them.

Overrides of `health_probe_status.critical_threshold` used the 0-1 scale before; now use percent (e.g. `100` instead of `1`, or `50` instead of `0.5`). The default planned threshold stays at 100 percent, but overrides are no longer multiplied by 100. Review `terraform plan` when upgrading.

## License

MIT
