# Architecture

This document explains how PANIC is designed and how the override mechanism works.

## Design Principles

1. **Decoupled monitoring** - Alerts deployed separately from resources
2. **Profile-based defaults** - Consistent thresholds across resource types
3. **Override flexibility** - Customize without losing profile benefits
4. **Independent versioning** - Each module versioned separately

## Deployment Model

Alerts are deployed as a separate monitoring layer:

```
┌─────────────────────────────────────────────────┐
│                  Your Resources                  │
│  (VMs, Databases, Storage, etc.)                │
└─────────────────────────────────────────────────┘
                        │
                        │ resource_id
                        ▼
┌─────────────────────────────────────────────────┐
│              PANIC Alert Modules                 │
│  (terraform-azurerm-monitor-*)                  │
└─────────────────────────────────────────────────┘
                        │
                        │ creates
                        ▼
┌─────────────────────────────────────────────────┐
│           Azure Monitor Alert Rules              │
│  (Metric alerts per resource)                   │
└─────────────────────────────────────────────────┘
```

Benefits:
- Independent lifecycle management
- Centralized monitoring configuration
- Consistent alerting across teams

## Override Mechanism

### Resolution Hierarchy

Values resolve in this order:

```
1. Override value (if specified)
       ↓
2. Profile default (Standard/Critical)
       ↓
3. Global fallback (base module)
```

### Override Structure

```hcl
overrides = {
  metric_name = {
    enabled            = bool
    warning_threshold  = number
    critical_threshold = number
    severity_warning   = number
    severity_critical  = number
    aggregation        = string
    window_minutes     = number
    frequency_minutes  = number
    evaluation_periods = number
    failing_periods    = number
  }
}
```

### Override Example

```hcl
module "vm_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vm.git?ref=v1.0.0"

  resource_id    = azurerm_virtual_machine.example.id
  resource_name  = "myapp-vm01"
  profile        = "standard"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    cpu = {
      warning_threshold  = 95
      critical_threshold = 99
    }
    memory = {
      enabled = false
    }
    disk_iops = {
      window_minutes = 15  # Longer evaluation window
    }
  }
}
```

## Module Architecture

### Base Module

The `terraform-azurerm-monitor-base` module creates individual metric alerts:

```hcl
module "alert" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-base.git?ref=v1.0.0"

  name              = "myapp-vm01-cpu-crit"
  resource_id       = "/subscriptions/.../virtualMachines/myapp-vm01"
  metric_name       = "Percentage CPU"
  threshold         = 95
  operator          = "GreaterThan"
  aggregation       = "Average"
  severity          = 1
  action_group_id   = "/subscriptions/.../actionGroups/ag-prod-critical"
}
```

### Resource Modules

Resource-specific modules (vm, storage, etc.) wrap the base module:

```
terraform-azurerm-monitor-vm/
├── main.tf        # Calls base module for each metric
├── profiles.tf    # Standard/Critical threshold definitions
├── defaults.tf    # Aggregation, window, frequency defaults
└── variables.tf   # resource_id, profile, overrides
```

## Naming Conventions

### Alert Rules

```
{resource-name}-{metric}-{level}
```

Examples:
- `myapp-vm01-cpu-warn`
- `myapp-vm01-cpu-crit`
- `prod-db-storage-crit`

### Action Groups

```
ag-{environment}-{severity}
```

Examples:
- `ag-prod-critical`
- `ag-prod-warning`
- `ag-nonprod-critical`

## Resource Group Placement

Alerts deploy to dedicated monitoring resource groups:

| Environment | Resource Group |
|-------------|----------------|
| Production | `rg-monitoring-prod` |
| Non-Production | `rg-monitoring-nonprod` |

## Tagging

Alert rules include operational metadata:

| Tag | Value |
|-----|-------|
| managed-by | terraform |
| module-version | x.y.z |

## Versioning

Modules use semantic versioning via Git tags:

```hcl
# Pin to specific version
source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vm.git?ref=v1.0.0"

# Use latest v1.x
source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vm.git?ref=v1"
```
