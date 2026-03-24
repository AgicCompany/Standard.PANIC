# terraform-azurerm-monitor-base

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Base Terraform module for creating Azure Monitor metric alerts. This module is used by resource-specific monitoring modules.

## Overview

This module creates a single Azure Monitor metric alert rule. It provides a standardized interface for alert creation that resource-specific modules can consume.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the metric alert rule | `string` | n/a | yes |
| resource_group_name | Resource group where the alert will be created | `string` | n/a | yes |
| resource_id | Resource ID of the target resource | `string` | n/a | yes |
| metric_namespace | Azure metric namespace | `string` | n/a | yes |
| metric_name | Name of the metric to monitor | `string` | n/a | yes |
| threshold | Threshold value for the alert | `number` | n/a | yes |
| action_group_id | Action group for notifications | `string` | n/a | yes |
| description | Description of the alert rule | `string` | `""` | no |
| severity | Alert severity (0-4) | `number` | `2` | no |
| enabled | Whether the alert is enabled | `bool` | `true` | no |
| auto_mitigate | Auto-resolve when condition clears | `bool` | `true` | no |
| frequency | Evaluation frequency (ISO 8601) | `string` | `"PT1M"` | no |
| window_size | Evaluation window (ISO 8601) | `string` | `"PT5M"` | no |
| aggregation | Metric aggregation type | `string` | `"Average"` | no |
| operator | Comparison operator | `string` | `"GreaterThan"` | no |
| dimensions | Dimension filters | `list(object)` | `[]` | no |
| tags | Resource tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the metric alert rule |
| name | Name of the metric alert rule |

## Usage

```hcl
module "cpu_alert" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/base?ref=base-v1.0.0"

  name                = "myvm-cpu-warn"
  resource_group_name = "rg-monitoring-dev"
  resource_id         = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Compute/virtualMachines/myvm"
  metric_namespace    = "Microsoft.Compute/virtualMachines"
  metric_name         = "Percentage CPU"
  aggregation         = "Average"
  operator            = "GreaterThan"
  threshold           = 85
  severity            = 2
  action_group_id     = "/subscriptions/.../resourceGroups/.../providers/microsoft.insights/actionGroups/ag-dev-warning"

  tags = {
    managed-by     = "terraform"
    module-version = "1.0.0"
  }
}
```

## License

MIT
