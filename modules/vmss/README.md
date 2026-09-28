# terraform-azurerm-monitor-vmss

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Thresholds for every module
- Full list of available modules

Terraform module for Virtual Machine Scale Set monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Scale-set-wide CPU, available memory and disk IOPS monitoring
- Scale-set availability (average of VM availability across instances)
- Platform metrics only: no Azure Monitor Agent required

## Monitored Metrics

All metrics are evaluated across the whole scale set (no per-instance split).

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| CPU | Percentage CPU (average across instances) | > 85% | > 95% | > 75% | > 90% |
| Memory | Available Memory Percentage | < 15% | < 10% | < 20% | < 15% |
| OS Disk IOPS | OS Disk IOPS Consumed Percentage | > 85% | > 95% | > 75% | > 90% |
| Data Disk IOPS | Data Disk IOPS Consumed Percentage | > 85% | > 95% | > 75% | > 90% |
| Availability | VmAvailabilityMetric average (1 = all up) | < 1 | < 0.5 | < 1 | < 0.75 |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "vmss_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vmss?ref=vmss/v1.0.0"

  resource_id         = azurerm_linux_virtual_machine_scale_set.web.id
  resource_name       = "web-vmss"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Overrides

```hcl
module "vmss_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vmss?ref=vmss/v1.0.0"

  resource_id         = azurerm_linux_virtual_machine_scale_set.batch.id
  resource_name       = "batch-vmss"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    cpu = {
      warning_threshold  = 90
      critical_threshold = 98
    }
    data_disk_iops = {
      enabled = false
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_id | Resource ID of the Virtual Machine Scale Set to monitor | `string` | n/a | yes |
| resource_name | Display name for the alerts (used in alert naming) | `string` | n/a | yes |
| resource_group_name | Resource group where the alerts will be created | `string` | n/a | yes |
| action_group_ids | Map of action group IDs for alert notifications | `object` | n/a | yes |
| profile | Alert profile to use (standard or critical) | `string` | `"standard"` | no |
| overrides | Optional overrides for specific metrics (`cpu`, `memory`, `os_disk_iops`, `data_disk_iops`, `availability`) | `object` | `{}` | no |
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

- **Scale-set scope**: alerts use the scale-set-level aggregate. One hot or failed instance can be hidden by the average; for per-instance alerts, use `modules/base` with a `VMName` dimension.
- **Availability**: `VmAvailabilityMetric` averaged across instances. `< 1` means at least one instance is unavailable.
- **Data disk IOPS**: scale sets without data disks publish no data, so this alert never fires. Disable it with an override if you prefer.
- **Orchestration mode**: verified against the scale-set metrics reference. Flexible orchestration supports scale-set-level host metrics for autoscale; check that all five metrics have data at scale-set scope in your environment.

## Tests

```bash
terraform init -backend=false
terraform test
```

## License

MIT
