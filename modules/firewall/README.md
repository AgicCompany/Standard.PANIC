# terraform-azurerm-monitor-firewall

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Firewall monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Firewall health and performance monitoring
- SNAT port exhaustion prevention
- Latency monitoring
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| Health State | Firewall health % | < 99% | < 95% | < 99.5% | < 99% |
| Throughput | Throughput in bits/sec (disabled) | Override required | Override required | Override required | Override required |
| SNAT Port Utilization | SNAT port usage % | > 80% | > 95% | > 70% | > 90% |
| Latency | Latency probe (ms) | > 20ms | > 50ms | > 10ms | > 30ms |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "firewall_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/firewall?ref=firewall/v1.0.0"

  resource_id         = azurerm_firewall.main.id
  resource_name       = "hub-firewall"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Throughput Thresholds

```hcl
module "firewall_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/firewall?ref=firewall/v1.0.0"

  resource_id         = azurerm_firewall.main.id
  resource_name       = "prod-firewall"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    throughput = {
      # Example raw bits/sec thresholds; size these for your workload.
      enabled            = true
      warning_threshold  = 1000000000 # 1 Gbps
      critical_threshold = 2000000000 # 2 Gbps
    }
    latency = {
      warning_threshold  = 5
      critical_threshold = 15
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
| resource_id | Resource ID of the Azure Firewall to monitor | `string` | n/a | yes |
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

- **Throughput thresholds**: Disabled by default in both profiles. `Throughput` is BitsPerSecond, not percent; enable it with `enabled = true` and raw bits/sec thresholds via `overrides.throughput`. Profile thresholds are placeholders, not recommended limits. See [supported metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-network-azurefirewalls-metrics).
- **SNAT port utilization** is critical for outbound connectivity. High utilization can cause connection failures.
- **Latency probe** uses `FirewallLatencyPng` with Average aggregation and thresholds in milliseconds. High values may indicate resource constraints.
- For **rule hit counts** and **data processed** metrics, consider using Azure Monitor workbooks for visibility.

## Migration (next major release, unreleased)

Throughput alerts are now disabled by default. Upgrading removes them unless you explicitly set `overrides.throughput.enabled = true` and both thresholds in raw bits/sec. A threshold-only override no longer enables them. Latency alerts now use the valid `FirewallLatencyPng` metric instead of `FirewallLatencyProbe`; thresholds remain in milliseconds. Health and SNAT utilization alerts are unchanged. Existing source pins still select the old behavior until you upgrade to the new major tag after release; review `terraform plan` when upgrading.

## License

MIT
