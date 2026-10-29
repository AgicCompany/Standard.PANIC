# terraform-azurerm-monitor-storage

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for creating Azure Monitor metric alerts for Storage Accounts.

## Overview

This module creates a comprehensive set of metric alerts for Azure Storage Accounts using a profile-based approach. It supports two profiles (standard and critical) with predefined thresholds, and allows metric-specific overrides.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| azurerm | >= 4.0, < 6.0 |

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| Availability | Storage account availability % | < 99.9% | < 99% | < 99.95% | < 99.5% |
| E2E Latency | End-to-end latency (ms) | > 500ms | > 1000ms | > 250ms | > 500ms |
| Throttling | Throttled transaction count | > 10 | > 100 | > 5 | > 50 |
| Used Capacity | Used capacity in bytes (disabled) | Override required | Override required | Override required | Override required |

`UsedCapacity` is bytes, not percent. It is disabled by default in both profiles; profile thresholds are placeholders, not recommended byte limits. Enable it with `enabled = true` and raw byte thresholds in `overrides.used_capacity`. See [supported metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-storage-storageaccounts-metrics).

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_id | Resource ID of the Storage Account | `string` | n/a | yes |
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
module "storage_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/storage?ref=storage/v1.0.1"

  resource_id         = azurerm_storage_account.example.id
  resource_name       = "dev-storage-01"
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
module "storage_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/storage?ref=storage/v1.0.1"

  resource_id         = azurerm_storage_account.critical.id
  resource_name       = "prod-critical-storage"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.prod_critical.id
    warning  = azurerm_monitor_action_group.prod_warning.id
  }

  overrides = {
    latency = {
      warning_threshold  = 100
      critical_threshold = 250
    }
    used_capacity = {
      # Example raw byte thresholds; size these for your workload.
      enabled            = true
      warning_threshold  = 1099511627776 # 1 TiB
      critical_threshold = 1649267441664 # 1.5 TiB
    }
  }
}
```

## Migration (next major release, unreleased)

Used capacity alerts are now disabled by default because `UsedCapacity` has no percentage equivalent. Upgrading removes existing capacity alerts unless you explicitly set `overrides.used_capacity.enabled = true`. If you relied on these alerts, also set both thresholds in bytes, as in the example above. A threshold-only override no longer enables them. Other alerts are unchanged. Existing source pins still select the old defaults until you upgrade to the new major tag after release; review `terraform plan` when upgrading.

## Alert Naming

Alerts follow the naming convention: `{resource_name}-{metric}-{level}`

Examples:
- `dev-storage-01-availability-warn`
- `dev-storage-01-availability-crit`
- `dev-storage-01-latency-warn`

## License

MIT
