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
| terraform | >= 1.3 |
| azurerm | >= 4.0, < 6.0 |

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Default |
|--------|-------------|---------------|---------------|---------------|---------------|---------|
| CPU % | CPU utilization | > 85 | > 95 | > 75 | > 90 | Enabled |
| Available Memory % | Available memory (platform metric) | < 15 | < 10 | < 20 | < 15 | Disabled |
| OS Disk IOPS % | OS disk IOPS consumed | > 85 | > 95 | > 75 | > 90 | Enabled |
| Data Disk IOPS % | Data disk IOPS consumed | > 85 | > 95 | > 75 | > 90 | Enabled |
| Disk Free % | Logical disk free space (guest metric, needs Azure Monitor Agent) | < 15 | < 10 | < 20 | < 15 | Disabled |
| VM Availability | VM availability status | - | < 1 | - | < 1 | Enabled |

Memory and Disk Free are disabled by default. Memory uses the `Available Memory Percentage` platform metric and needs no agent.

Disk Free uses a guest metric from Azure Monitor Agent, selected by `os_type`:

| `os_type` | Namespace | Metric |
|-----------|-----------|--------|
| `linux` (default) | `Azure.VM.Linux.GuestMetrics` | `disk/free_percent` |
| `windows` | `Azure.VM.Windows.GuestMetrics` | `\LogicalDisk(_Total)\% Free Space` |

The alert only works if the VM publishes these metrics (checked on a Linux and a Windows VM in a lab subscription):

- The Azure Monitor Agent extension is installed and the VM has a managed identity.
- A data collection rule with an **Azure Monitor Metrics** destination (stream `Microsoft-InsightsMetrics`) is associated with the VM and collects the free-space counter: `Logical Disk(*)\% Free Space` on Linux, `\LogicalDisk(_Total)\% Free Space` on Windows. On Windows the metric name is the counter you configure, so use that exact counter.
- The VM can reach Azure Monitor over the network (outbound access to `*.handler.control.monitor.azure.com` and `<region>.monitoring.azure.com`).
- The VM identity has the `Monitoring Metrics Publisher` role on the VM.

Without these the alert never gets data. The Azure CLI commands `az monitor metrics list-namespaces` and `list-definitions` may not list guest namespaces even when data flows; query the metrics API with the namespace and metric name instead.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_id | Resource ID of the Virtual Machine | `string` | n/a | yes |
| resource_name | Display name for alerts | `string` | n/a | yes |
| resource_group_name | Resource group for alerts | `string` | n/a | yes |
| action_group_ids | Map with critical/warning action group IDs | `object` | n/a | yes |
| profile | Alert profile (standard or critical) | `string` | `"standard"` | no |
| os_type | Guest OS (`linux` or `windows`), selects the `disk_free` guest metric | `string` | `"linux"` | no |
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
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vm?ref=vm/v1.1.0"

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
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vm?ref=vm/v1.1.0"

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
    memory = {
      enabled = true
    }
  }
}
```

### Enabling the Memory Alert

The memory alert is a platform metric and needs no agent. Enable it via overrides:

```hcl
overrides = {
  memory = {
    enabled = true
  }
}
```

### Enabling the Disk Free Alert

Set `os_type` to match the VM, then enable the alert (see the prerequisites above):

```hcl
os_type = "windows"

overrides = {
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
