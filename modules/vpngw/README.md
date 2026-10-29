# terraform-azurerm-monitor-vpngw

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure VPN Gateway monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Site-to-site tunnel monitoring
- Point-to-site VPN monitoring (optional)
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| Tunnel Status | Inbound packet count, not tunnel state (disabled) | - | < 1 packet (opt-in) | - | < 1 packet (opt-in) |
| Tunnel Bandwidth | Tunnel bandwidth in Bytes/sec (disabled) | Override required | Override required | Override required | Override required |
| P2S Bandwidth | Point-to-site bandwidth in Bytes/sec (disabled) | Override required | Override required | Override required | Override required |
| P2S Connection Count | P2S client count (disabled) | Override required | Override required | Override required | Override required |
| Tunnel Drop Count | Dropped packets per tunnel | > 5 | > 20 | > 2 | > 10 |

**Note:** Only Tunnel Drop Count is enabled by default. Enable P2S metrics only for Point-to-Site VPN configurations, with raw-unit thresholds.

## Usage

### Basic Usage (Site-to-Site VPN)

```hcl
module "vpngw_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vpngw?ref=vpngw/v2.0.0"

  resource_id         = azurerm_virtual_network_gateway.main.id
  resource_name       = "prod-vpn-gateway"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Point-to-Site VPN with Overrides

```hcl
module "vpngw_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vpngw?ref=vpngw/v2.0.0"

  resource_id         = azurerm_virtual_network_gateway.p2s.id
  resource_name       = "remote-access-vpn"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    p2s_bandwidth = {
      # Example raw Bytes/sec thresholds; size these for your workload.
      enabled            = true
      warning_threshold  = 1048576
      critical_threshold = 2097152
    }
    p2s_connection_count = {
      enabled            = true
      warning_threshold  = 100
      critical_threshold = 150
    }
    tunnel_bandwidth = {
      enabled = false  # Disable S2S if not used
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
| resource_id | Resource ID of the VPN Gateway to monitor | `string` | n/a | yes |
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

- **Tunnel Status** is disabled because no tunnel state metric exists on `Microsoft.Network/virtualNetworkGateways`. It uses `TunnelIngressPackets` (Count, Total) with `LessThan 1`; enabling it alerts when no inbound packets arrive, including on healthy idle tunnels. It does not detect tunnel state.
- **P2S metrics** stay disabled by default. `P2SBandwidth` uses Bytes/sec and `P2SConnectionCount` uses Count. Enable them only for Point-to-Site VPN, with both thresholds in raw units.
- **Tunnel bandwidth** is disabled by default in both profiles. `TunnelAverageBandwidth` uses Bytes/sec, not percent; enable it with `enabled = true` and raw Bytes/sec thresholds in `overrides.tunnel_bandwidth`. Profile bandwidth and P2S thresholds are placeholders, not recommended limits. See [supported metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-network-virtualnetworkgateways-metrics).

## Migration (v2.0.0)

Tunnel status and tunnel bandwidth alerts are now disabled by default. Upgrading removes them unless you explicitly enable them. A threshold-only override no longer enables them. For bandwidth, set both thresholds in Bytes/sec. For `tunnel_status`, the metric changes from `TunnelAverageBandwidth` to `TunnelIngressPackets`, aggregation changes to Total, and the threshold remains `LessThan 1` packet: enable only if idle-tunnel alerts are wanted, not as a tunnel-state check. P2S metrics stay disabled and need raw Bytes/sec or Count overrides when enabled. Review `terraform plan` when upgrading.

## License

MIT
