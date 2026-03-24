# terraform-azurerm-monitor-vm

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for creating Azure Monitor metric alerts for Virtual Machines.

## Overview

This module creates a comprehensive set of metric alerts for Azure Virtual Machines using a profile-based approach. It supports two profiles (standard and critical) with predefined thresholds, and allows metric-specific overrides.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Default |
|--------|-------------|---------------|---------------|---------------|---------------|---------|
| CPU % | CPU utilization | > 85 | > 95 | > 75 | > 90 | Enabled |
| Available Memory % | Available memory* | < 15 | < 10 | < 20 | < 15 | Disabled |
| OS Disk IOPS % | OS disk IOPS consumed | > 85 | > 95 | > 75 | > 90 | Enabled |
| Data Disk IOPS % | Data disk IOPS consumed | > 85 | > 95 | > 75 | > 90 | Enabled |
| Disk Free % | Logical disk free space* | < 15 | < 10 | < 20 | < 15 | Disabled |
| VM Availability | VM availability status | - | < 1 | - | < 1 | Enabled |

*Memory and Disk Free metrics require Azure Monitor Agent (AMA) with Data Collection Rules configured. These are disabled by default.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_id | Resource ID of the Virtual Machine | `string` | n/a | yes |
| resource_name | Display name for alerts | `string` | n/a | yes |
| resource_group_name | Resource group for alerts | `string` | n/a | yes |
| action_group_ids | Map with critical/warning action group IDs | `object` | n/a | yes |
| profile | Alert profile (standard or critical) | `string` | `"standard"` | no |
| overrides | Metric-specific threshold overrides | `object` | `{}` | no |
| enabled | Enable/disable all alerts | `bool` | `true` | no |
| tags | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alert_ids | Map of created alert rule IDs |
| alert_names | Map of created alert rule names |
| profile | The alert profile used |
| resolved_thresholds | Final threshold values after overrides |

## Usage

### Standard Profile

```hcl
module "vm_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vm?ref=vm/v1.0.0"

  resource_id         = azurerm_linux_virtual_machine.example.id
  resource_name       = "dev-vm-01"
  resource_group_name = "rg-monitoring-dev"
  profile             = "standard"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Overrides

```hcl
module "vm_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vm?ref=vm/v1.0.0"

  resource_id         = azurerm_linux_virtual_machine.production.id
  resource_name       = "prod-db-01"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.prod_critical.id
    warning  = azurerm_monitor_action_group.prod_warning.id
  }

  overrides = {
    cpu = {
      warning_threshold  = 70
      critical_threshold = 85
    }
    # Enable guest metrics if AMA is configured
    memory = {
      enabled = true
    }
    disk_free = {
      enabled            = true
      warning_threshold  = 25
      critical_threshold = 15
    }
  }
}
```

### Enabling Guest Metrics

To use memory and disk free percentage alerts, you need:

1. Azure Monitor Agent installed on the VM
2. Data Collection Rule configured to collect guest metrics
3. Enable the metrics via overrides:

```hcl
overrides = {
  memory = {
    enabled = true
  }
  disk_free = {
    enabled = true
  }
}
```

## Alert Naming

Alerts follow the naming convention: `{resource_name}-{metric}-{level}`

Examples:
- `dev-vm-01-cpu-warn`
- `dev-vm-01-cpu-crit`
- `prod-db-01-availability-crit`

## License

MIT
