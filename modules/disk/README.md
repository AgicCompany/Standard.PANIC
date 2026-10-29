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
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| IOPS Consumed | Disk read operations/sec (disabled) | Override required | Override required | Override required | Override required |
| Bandwidth Consumed | Disk read bytes/sec (disabled) | Override required | Override required | Override required | Override required |
| Queue Depth | Not available (disabled) | - | - | - | - |
| Burst BPS Credits | Not available (disabled) | - | - | - | - |
| Burst IO Credits | Not available (disabled) | - | - | - | - |

**All alerts are disabled by default.** `Microsoft.Compute/disks` only exposes raw rate metrics (read/write operations per second, read/write bytes per second) and `DiskPaidBurstIOPS`. It has no percentage, queue depth, or burst credit metrics ([supported metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-compute-disks-metrics)).

- `iops_consumed` and `bandwidth_consumed` work if you enable them with raw thresholds sized to the disk's limits (operations/sec and bytes/sec).
- `queue_depth`, `burst_bps_credits` and `burst_io_credits` do not work: none of these metrics exist on disks, so enabling them makes the apply fail. Do not enable them.
- For percentage-based disk monitoring (IOPS, bandwidth, queue depth, burst credits), use the VM-level `OS Disk ...` / `Data Disk ...` metrics. The [`vm`](../vm/) module covers `OS Disk IOPS Consumed Percentage` and `Data Disk IOPS Consumed Percentage`.

## Usage

### Basic Usage (Standard Profile)

```hcl
module "disk_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/disk?ref=disk/v2.0.0"

  resource_id         = azurerm_managed_disk.data.id
  resource_name       = "myvm-data-disk"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Raw Thresholds

```hcl
module "disk_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/disk?ref=disk/v2.0.0"

  resource_id         = azurerm_managed_disk.premium.id
  resource_name       = "production-data-disk"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  # P30 disk: 5,000 IOPS and 200 MB/s limits
  overrides = {
    iops_consumed = {
      enabled            = true
      warning_threshold  = 3750 # read ops/sec, 75% of 5,000
      critical_threshold = 4500 # 90%
    }
    bandwidth_consumed = {
      enabled            = true
      warning_threshold  = 157286400 # read bytes/sec, 75% of 200 MiB/s
      critical_threshold = 188743680 # 90%
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

- The IOPS and bandwidth alerts only watch **read** operations and bytes (`Composite Disk Read ...`), not writes.
- See the note under Monitored Metrics for which alerts are usable.

## License

MIT
