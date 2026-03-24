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
| Tunnel Status | VPN tunnel connectivity | - | < 1 | - | < 1 |
| Tunnel Bandwidth | Tunnel bandwidth usage | > 80% | > 95% | > 70% | > 90% |
| P2S Bandwidth | Point-to-site bandwidth | > 80% | > 95% | > 70% | > 90% |
| P2S Connection Count | P2S client connections | > 80% | > 95% | > 70% | > 90% |
| Tunnel Drop Count | Dropped packets per tunnel | > 5 | > 20 | > 2 | > 10 |

**Note:** P2S metrics are disabled by default and should only be enabled for Point-to-Site VPN configurations.

## Usage

### Basic Usage (Site-to-Site VPN)

```hcl
module "vpngw_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vpngw?ref=vpngw-v1.0.0"

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
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vpngw?ref=vpngw-v1.0.0"

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
      enabled = true  # Enable P2S monitoring
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
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

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

- **Tunnel Status** uses bandwidth as a proxy for tunnel health. A value of 0 indicates the tunnel is down.
- **P2S metrics** are disabled by default. Enable them only for gateways configured with Point-to-Site VPN.
- **Bandwidth thresholds** should be adjusted based on your gateway SKU limits.

## License

MIT
