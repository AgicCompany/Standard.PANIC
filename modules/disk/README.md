# terraform-azurerm-monitor-disk

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Managed Disk monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Burst credit monitoring for Premium SSD disks
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| IOPS Consumed | Disk IOPS utilization % | > 85% | > 95% | > 75% | > 90% |
| Bandwidth Consumed | Disk throughput utilization % | > 85% | > 95% | > 75% | > 90% |
| Queue Depth | I/O queue depth (saturation) | > 32 | > 64 | > 16 | > 32 |
| Burst BPS Credits | Remaining burst bandwidth credits | < 20% | < 10% | < 30% | < 20% |
| Burst IO Credits | Remaining burst IOPS credits | < 20% | < 10% | < 30% | < 20% |

**Note:** Burst credit metrics are disabled by default and should only be enabled for disks with bursting capabilities (Premium SSD with on-demand bursting).

## Usage

### Basic Usage (Standard Profile)

```hcl
module "disk_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/disk?ref=disk-v1.0.0"

  resource_id         = azurerm_managed_disk.data.id
  resource_name       = "myvm-data-disk"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Burst Monitoring

```hcl
module "disk_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/disk?ref=disk-v1.0.0"

  resource_id         = azurerm_managed_disk.premium.id
  resource_name       = "production-data-disk"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    burst_bps_credits = {
      enabled = true  # Enable for Premium SSD with bursting
    }
    burst_io_credits = {
      enabled = true
    }
    queue_depth = {
      enabled = false  # Disable if not needed
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
| resource_id | Resource ID of the Managed Disk to monitor | `string` | n/a | yes |
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

- **Burst credit metrics** are only available on Premium SSD disks with bursting enabled. Keep these disabled for other disk types.
- **Queue depth** monitoring may not be available on all disk SKUs.
- For percentage-based IOPS/bandwidth monitoring relative to disk limits, consider using VM-level metrics (`Data Disk IOPS Consumed Percentage`, `Data Disk Bandwidth Consumed Percentage`).

## License

MIT
