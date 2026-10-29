# terraform-azurerm-monitor-expressroute

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure ExpressRoute Circuit monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- BGP and ARP availability monitoring
- Bandwidth utilization monitoring
- Packet drop detection
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| BGP Availability | BGP session availability % | < 99.9% | < 99% | < 99.95% | < 99.5% |
| ARP Availability | ARP availability % | < 99.9% | < 99% | < 99.95% | < 99.5% |
| Bits In | Ingress link bandwidth utilization % (Maximum) | > 80% | > 95% | > 70% | > 90% |
| Bits Out | Egress link bandwidth utilization % (Maximum) | > 80% | > 95% | > 70% | > 90% |
| Dropped Packets In | Ingress drops/sec | > 10 | > 100 | > 5 | > 50 |
| Dropped Packets Out | Egress drops/sec | > 10 | > 100 | > 5 | > 50 |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "expressroute_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/expressroute?ref=expressroute/v2.0.0"

  resource_id         = azurerm_express_route_circuit.main.id
  resource_name       = "prod-expressroute"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Bandwidth Thresholds

```hcl
module "expressroute_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/expressroute?ref=expressroute/v2.0.0"

  resource_id         = azurerm_express_route_circuit.main.id
  resource_name       = "dc-interconnect"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    bits_in = {
      # Percent of link bandwidth, not bits per second
      warning_threshold  = 80
      critical_threshold = 95
    }
    bits_out = {
      warning_threshold  = 80
      critical_threshold = 95
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
| resource_id | Resource ID of the ExpressRoute Circuit to monitor | `string` | n/a | yes |
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

- **Bandwidth thresholds** are percentages of link bandwidth. `bits_in` uses `IngressBandwidthUtilization` and `bits_out` uses `EgressBandwidthUtilization`, both with Maximum aggregation. These circuit traffic metrics expose `PeeringType` and `DeviceRole` dimensions; this module adds no dimension filters. See [supported metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-network-expressroutecircuits-metrics).
- **BGP/ARP availability** are critical indicators of circuit health. Values below 100% indicate connectivity issues.
- For **Global Reach** monitoring, create additional alerts targeting the GlobalReachBitsInPerSecond/GlobalReachBitsOutPerSecond metrics.

## Migration (v2.0.0)

`bits_in` and `bits_out` now use link bandwidth utilization percentage metrics instead of `BitsInPerSecond` and `BitsOutPerSecond`, and aggregation changes from Average to Maximum. Both remain enabled with standard 80/95 and critical 70/90 percent thresholds. Convert any raw bits/sec overrides to percentages before upgrading. Review `terraform plan` when upgrading. Other metrics are unchanged.

## License

MIT
