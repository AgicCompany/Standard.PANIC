---
title: vmss alert module implementation plan
date: 2026-09-28
status: draft
version: 0.1
---

# vmss Alert Module Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `modules/vmss` so `templates/panic-subscription-template/vmss.tf` initializes once `vmss/v1.0.0` is tagged.

**Architecture:** A new resource module in the newer module style (like `modules/aks`): profiles in `profiles.tf`, metric definitions and `coalesce(try(...))` override merge in `defaults.tf`, one warn/crit `azurerm_monitor_metric_alert` pair per metric in `main.tf`. Docs and the thresholds generator learn about the new module.

**Tech Stack:** Terraform (>= 1.3 declared; 1.7+ to run `terraform test`), `hashicorp/azurerm`, `terraform test` with `mock_provider`, Python 3 + `python-hcl2` for `scripts/gen-thresholds.py`.

**Spec:** `docs/specs/2026-09-28-vmss-module.md` (active v1.0)

**Working directory:** `/home/molaru/projects/Standard.PANIC-vmss` (branch `feat/vmss-module`). All paths below are relative to it.

## Global Constraints

- Namespace: `Microsoft.Compute/virtualMachineScaleSets`. No dimension filter or split on any alert.
- Metrics, keys and suffixes exactly as in the spec table: `cpu`/`cpu`, `memory`/`memory`, `os_disk_iops`/`osdiskiops`, `data_disk_iops`/`datadiskiops`, `availability`/`availability`.
- All five metrics enabled in both profiles; all windows 5 minutes.
- Severity 2 (warn) / 1 (crit); frequency `PT1M`; `auto_mitigate = true`.
- Alert name: `${var.resource_name}-<suffix>-{warn,crit}`.
- Override merge: `coalesce(try(var.overrides.<metric>.<field>, null), local.selected_profile.<metric>.<field>)`. Never plain `try(..., <profile>)`.
- Tags: `merge(var.tags, { managed-by = "terraform" })`. No `module-version` tag.
- `versions.tf`: `required_version = ">= 1.3"`, `azurerm >= 3.0`.
- Descriptions: "exceeded X" for `>`, "below X" for `<`; `%` for percent metrics, no `%` for `availability`.
- Don't modify `modules/vm` or `templates/`.
- Commit messages: Conventional Commits, no AI attribution.

## Review Focus

- `overrides = null` (the template's default for an entry without overrides) must create all 10 alerts. Covered by Task 1 test `null_overrides_from_template`.
- String-typed override values must convert: `"90"` -> 90, `"false"` -> disabled. (The template's `map(any)` rejects mixed override shapes before they reach the module; that's a separate template bug, see the spec's Known limitation.) Covered by `string_overrides_from_template_map_any`.
- An override of `0` must be kept, not replaced by the profile value (`coalesce` only skips null). Covered by `zero_threshold_override_is_kept`.
- An unknown profile (`"gold"`) must fail at plan with the validation message. Covered by `invalid_profile_rejected`.
- The availability description must not claim a percent. Covered by the description assert in `defaults_create_all_alerts`.

---

### Task 1: Module core with tests

**Files:**
- Create: `modules/vmss/versions.tf`
- Create: `modules/vmss/variables.tf`
- Create: `modules/vmss/tests/overrides.tftest.hcl`
- Create: `modules/vmss/profiles.tf`
- Create: `modules/vmss/defaults.tf`
- Create: `modules/vmss/main.tf`
- Create: `modules/vmss/outputs.tf`

**Interfaces:**
- Consumes: nothing.
- Produces: module inputs `resource_id`, `resource_name`, `resource_group_name`, `action_group_ids {critical, warning}`, `profile`, `enabled`, `tags`, `overrides`; outputs `alert_ids`, `alert_names` (keys `<metric>_warn`, `<metric>_crit`), `profile`, `resolved_thresholds`. Task 2's examples and Task 3's generator rely on these exact names; the template's `vmss.tf` passes exactly these inputs.

- [ ] **Step 1: Create the interface files**

`modules/vmss/versions.tf`:

```hcl
terraform {
  required_version = ">= 1.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}
```

`modules/vmss/variables.tf`:

```hcl
variable "resource_id" {
  description = "The resource ID of the Virtual Machine Scale Set to monitor"
  type        = string
}

variable "resource_name" {
  description = "Display name for the alerts (used in alert naming)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the alerts will be created"
  type        = string
}

variable "action_group_ids" {
  description = "Map of action group IDs for alert notifications"
  type = object({
    critical = string
    warning  = string
  })
}

variable "profile" {
  description = "Alert profile to use (standard or critical)"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "critical"], var.profile)
    error_message = "Profile must be either 'standard' or 'critical'."
  }
}

variable "enabled" {
  description = "Enable or disable all alerts"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all alerts"
  type        = map(string)
  default     = {}
}

variable "overrides" {
  description = "Optional overrides for specific metrics"
  type = object({
    cpu = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    memory = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    os_disk_iops = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    data_disk_iops = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
    availability = optional(object({
      enabled            = optional(bool)
      warning_threshold  = optional(number)
      critical_threshold = optional(number)
      window_minutes     = optional(number)
    }))
  })
  default = {}
}
```

- [ ] **Step 2: Write the tests**

`modules/vmss/tests/overrides.tftest.hcl`:

```hcl
# Default alerts and override behavior for the vmss module.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test"
  resource_name       = "vmss-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "defaults_create_all_alerts" {
  command = plan

  assert {
    condition     = length([for id in values(output.alert_names) : id if id != null]) == 10
    error_message = "all 10 alerts (5 metrics x warn/crit) must be created by default"
  }

  assert {
    condition = output.resolved_thresholds == {
      cpu            = { enabled = true, warning_threshold = 85, critical_threshold = 95, window_minutes = 5 }
      memory         = { enabled = true, warning_threshold = 15, critical_threshold = 10, window_minutes = 5 }
      os_disk_iops   = { enabled = true, warning_threshold = 85, critical_threshold = 95, window_minutes = 5 }
      data_disk_iops = { enabled = true, warning_threshold = 85, critical_threshold = 95, window_minutes = 5 }
      availability   = { enabled = true, warning_threshold = 1, critical_threshold = 0.5, window_minutes = 5 }
    }
    error_message = "standard profile values do not match the spec"
  }

  assert {
    condition     = azurerm_monitor_metric_alert.availability_crit[0].name == "vmss-test-availability-crit" && azurerm_monitor_metric_alert.os_disk_iops_warn[0].name == "vmss-test-osdiskiops-warn"
    error_message = "alert names must be {resource_name}-{suffix}-{warn|crit}"
  }

  assert {
    condition     = azurerm_monitor_metric_alert.availability_crit[0].description == "Critical: Scale set average VM availability (1 = all instances available) below 0.5"
    error_message = "availability description must say 'below' with no percent sign"
  }
}

run "critical_profile" {
  command = plan

  variables {
    profile = "critical"
  }

  assert {
    condition     = output.resolved_thresholds.availability.critical_threshold == 0.75 && output.resolved_thresholds.cpu.warning_threshold == 75
    error_message = "critical profile values do not match the spec"
  }
}

run "partial_override_keeps_profile_defaults" {
  command = plan

  variables {
    overrides = {
      cpu = { warning_threshold = 90 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.cpu_warn) == 1 && length(azurerm_monitor_metric_alert.cpu_crit) == 1
    error_message = "cpu alerts must still be created when only warning_threshold is overridden"
  }

  assert {
    condition     = output.resolved_thresholds.cpu.warning_threshold == 90 && output.resolved_thresholds.cpu.critical_threshold == 95 && output.resolved_thresholds.cpu.window_minutes == 5
    error_message = "cpu fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      cpu = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.cpu_warn) == 0 && length(azurerm_monitor_metric_alert.cpu_crit) == 0
    error_message = "enabled = false must remove the cpu alerts"
  }
}

run "module_disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length([for id in values(output.alert_names) : id if id != null]) == 0
    error_message = "enabled = false on the module must create no alerts"
  }
}

run "null_overrides_from_template" {
  command = plan

  variables {
    overrides = null
  }

  assert {
    condition     = length([for id in values(output.alert_names) : id if id != null]) == 10
    error_message = "overrides = null (what the template passes) must create all 10 alerts"
  }
}

run "string_overrides_from_template_map_any" {
  command = plan

  variables {
    overrides = {
      cpu    = { warning_threshold = "90" }
      memory = { enabled = "false" }
    }
  }

  assert {
    condition     = output.resolved_thresholds.cpu.warning_threshold == 90
    error_message = "string threshold from map(any) must convert to a number"
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.memory_warn) == 0 && length(azurerm_monitor_metric_alert.memory_crit) == 0
    error_message = "string \"false\" from map(any) must disable the metric"
  }
}

run "zero_threshold_override_is_kept" {
  command = plan

  variables {
    overrides = {
      availability = { critical_threshold = 0 }
    }
  }

  assert {
    condition     = output.resolved_thresholds.availability.critical_threshold == 0
    error_message = "a 0 threshold override must not fall back to the profile value"
  }
}

run "invalid_profile_rejected" {
  command = plan

  variables {
    profile = "gold"
  }

  expect_failures = [var.profile]
}
```

- [ ] **Step 3: Run the tests to verify they fail**

Run: `terraform -chdir=modules/vmss init -backend=false -input=false && terraform -chdir=modules/vmss test`
Expected: FAIL. Errors reference undeclared resources/outputs (e.g. `Reference to undeclared output value` or `undeclared resource`), because only the interface exists.

- [ ] **Step 4: Write the profiles**

`modules/vmss/profiles.tf`:

```hcl
locals {
  # Thresholds per profile. All metrics are platform metrics; no agent needed.
  # memory and availability use LessThan: lower values are worse.
  profiles = {
    standard = {
      cpu = {
        enabled            = true
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      memory = {
        enabled            = true
        warning_threshold  = 15
        critical_threshold = 10
        window_minutes     = 5
      }
      os_disk_iops = {
        enabled            = true
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      data_disk_iops = {
        enabled            = true
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      availability = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 0.5
        window_minutes     = 5
      }
    }
    critical = {
      cpu = {
        enabled            = true
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      memory = {
        enabled            = true
        warning_threshold  = 20
        critical_threshold = 15
        window_minutes     = 5
      }
      os_disk_iops = {
        enabled            = true
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      data_disk_iops = {
        enabled            = true
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      availability = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 0.75
        window_minutes     = 5
      }
    }
  }
}
```

- [ ] **Step 5: Write metric definitions and override merge**

`modules/vmss/defaults.tf`:

```hcl
locals {
  # Metric namespace for Virtual Machine Scale Sets
  metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"

  # Metric definitions. No dimension filter: every alert evaluates the whole scale set.
  metrics = {
    cpu = {
      name        = "Percentage CPU"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Scale set CPU usage percentage"
    }
    memory = {
      name        = "Available Memory Percentage"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Scale set available memory percentage"
    }
    os_disk_iops = {
      name        = "OS Disk IOPS Consumed Percentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Scale set OS disk IOPS consumed percentage"
    }
    data_disk_iops = {
      name        = "Data Disk IOPS Consumed Percentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Scale set data disk IOPS consumed percentage"
    }
    availability = {
      name        = "VmAvailabilityMetric"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Scale set average VM availability (1 = all instances available)"
    }
  }

  # Select the profile
  selected_profile = local.profiles[var.profile]

  # Resolved configuration: override value if set, else profile value
  resolved = {
    cpu = {
      enabled            = coalesce(try(var.overrides.cpu.enabled, null), local.selected_profile.cpu.enabled)
      warning_threshold  = coalesce(try(var.overrides.cpu.warning_threshold, null), local.selected_profile.cpu.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.cpu.critical_threshold, null), local.selected_profile.cpu.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.cpu.window_minutes, null), local.selected_profile.cpu.window_minutes)
    }
    memory = {
      enabled            = coalesce(try(var.overrides.memory.enabled, null), local.selected_profile.memory.enabled)
      warning_threshold  = coalesce(try(var.overrides.memory.warning_threshold, null), local.selected_profile.memory.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.memory.critical_threshold, null), local.selected_profile.memory.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.memory.window_minutes, null), local.selected_profile.memory.window_minutes)
    }
    os_disk_iops = {
      enabled            = coalesce(try(var.overrides.os_disk_iops.enabled, null), local.selected_profile.os_disk_iops.enabled)
      warning_threshold  = coalesce(try(var.overrides.os_disk_iops.warning_threshold, null), local.selected_profile.os_disk_iops.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.os_disk_iops.critical_threshold, null), local.selected_profile.os_disk_iops.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.os_disk_iops.window_minutes, null), local.selected_profile.os_disk_iops.window_minutes)
    }
    data_disk_iops = {
      enabled            = coalesce(try(var.overrides.data_disk_iops.enabled, null), local.selected_profile.data_disk_iops.enabled)
      warning_threshold  = coalesce(try(var.overrides.data_disk_iops.warning_threshold, null), local.selected_profile.data_disk_iops.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.data_disk_iops.critical_threshold, null), local.selected_profile.data_disk_iops.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.data_disk_iops.window_minutes, null), local.selected_profile.data_disk_iops.window_minutes)
    }
    availability = {
      enabled            = coalesce(try(var.overrides.availability.enabled, null), local.selected_profile.availability.enabled)
      warning_threshold  = coalesce(try(var.overrides.availability.warning_threshold, null), local.selected_profile.availability.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.availability.critical_threshold, null), local.selected_profile.availability.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.availability.window_minutes, null), local.selected_profile.availability.window_minutes)
    }
  }

  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
```

- [ ] **Step 6: Write the alert resources**

`modules/vmss/main.tf`:

```hcl
# CPU Alerts
resource "azurerm_monitor_metric_alert" "cpu_warn" {
  count = var.enabled && local.resolved.cpu.enabled ? 1 : 0

  name                = "${var.resource_name}-cpu-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.cpu.description} exceeded ${local.resolved.cpu.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.cpu.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.cpu.name
    aggregation      = local.metrics.cpu.aggregation
    operator         = local.metrics.cpu.operator
    threshold        = local.resolved.cpu.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "cpu_crit" {
  count = var.enabled && local.resolved.cpu.enabled ? 1 : 0

  name                = "${var.resource_name}-cpu-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.cpu.description} exceeded ${local.resolved.cpu.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.cpu.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.cpu.name
    aggregation      = local.metrics.cpu.aggregation
    operator         = local.metrics.cpu.operator
    threshold        = local.resolved.cpu.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Available Memory Alerts
resource "azurerm_monitor_metric_alert" "memory_warn" {
  count = var.enabled && local.resolved.memory.enabled ? 1 : 0

  name                = "${var.resource_name}-memory-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.memory.description} below ${local.resolved.memory.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.memory.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.memory.name
    aggregation      = local.metrics.memory.aggregation
    operator         = local.metrics.memory.operator
    threshold        = local.resolved.memory.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "memory_crit" {
  count = var.enabled && local.resolved.memory.enabled ? 1 : 0

  name                = "${var.resource_name}-memory-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.memory.description} below ${local.resolved.memory.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.memory.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.memory.name
    aggregation      = local.metrics.memory.aggregation
    operator         = local.metrics.memory.operator
    threshold        = local.resolved.memory.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# OS Disk IOPS Alerts
resource "azurerm_monitor_metric_alert" "os_disk_iops_warn" {
  count = var.enabled && local.resolved.os_disk_iops.enabled ? 1 : 0

  name                = "${var.resource_name}-osdiskiops-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.os_disk_iops.description} exceeded ${local.resolved.os_disk_iops.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.os_disk_iops.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.os_disk_iops.name
    aggregation      = local.metrics.os_disk_iops.aggregation
    operator         = local.metrics.os_disk_iops.operator
    threshold        = local.resolved.os_disk_iops.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "os_disk_iops_crit" {
  count = var.enabled && local.resolved.os_disk_iops.enabled ? 1 : 0

  name                = "${var.resource_name}-osdiskiops-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.os_disk_iops.description} exceeded ${local.resolved.os_disk_iops.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.os_disk_iops.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.os_disk_iops.name
    aggregation      = local.metrics.os_disk_iops.aggregation
    operator         = local.metrics.os_disk_iops.operator
    threshold        = local.resolved.os_disk_iops.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Data Disk IOPS Alerts
resource "azurerm_monitor_metric_alert" "data_disk_iops_warn" {
  count = var.enabled && local.resolved.data_disk_iops.enabled ? 1 : 0

  name                = "${var.resource_name}-datadiskiops-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.data_disk_iops.description} exceeded ${local.resolved.data_disk_iops.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.data_disk_iops.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.data_disk_iops.name
    aggregation      = local.metrics.data_disk_iops.aggregation
    operator         = local.metrics.data_disk_iops.operator
    threshold        = local.resolved.data_disk_iops.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "data_disk_iops_crit" {
  count = var.enabled && local.resolved.data_disk_iops.enabled ? 1 : 0

  name                = "${var.resource_name}-datadiskiops-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.data_disk_iops.description} exceeded ${local.resolved.data_disk_iops.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.data_disk_iops.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.data_disk_iops.name
    aggregation      = local.metrics.data_disk_iops.aggregation
    operator         = local.metrics.data_disk_iops.operator
    threshold        = local.resolved.data_disk_iops.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# VM Availability Alerts
resource "azurerm_monitor_metric_alert" "availability_warn" {
  count = var.enabled && local.resolved.availability.enabled ? 1 : 0

  name                = "${var.resource_name}-availability-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.availability.description} below ${local.resolved.availability.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.availability.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.availability.name
    aggregation      = local.metrics.availability.aggregation
    operator         = local.metrics.availability.operator
    threshold        = local.resolved.availability.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "availability_crit" {
  count = var.enabled && local.resolved.availability.enabled ? 1 : 0

  name                = "${var.resource_name}-availability-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.availability.description} below ${local.resolved.availability.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.availability.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.availability.name
    aggregation      = local.metrics.availability.aggregation
    operator         = local.metrics.availability.operator
    threshold        = local.resolved.availability.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
```

- [ ] **Step 7: Write the outputs**

`modules/vmss/outputs.tf`:

```hcl
output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    cpu_warn            = try(azurerm_monitor_metric_alert.cpu_warn[0].id, null)
    cpu_crit            = try(azurerm_monitor_metric_alert.cpu_crit[0].id, null)
    memory_warn         = try(azurerm_monitor_metric_alert.memory_warn[0].id, null)
    memory_crit         = try(azurerm_monitor_metric_alert.memory_crit[0].id, null)
    os_disk_iops_warn   = try(azurerm_monitor_metric_alert.os_disk_iops_warn[0].id, null)
    os_disk_iops_crit   = try(azurerm_monitor_metric_alert.os_disk_iops_crit[0].id, null)
    data_disk_iops_warn = try(azurerm_monitor_metric_alert.data_disk_iops_warn[0].id, null)
    data_disk_iops_crit = try(azurerm_monitor_metric_alert.data_disk_iops_crit[0].id, null)
    availability_warn   = try(azurerm_monitor_metric_alert.availability_warn[0].id, null)
    availability_crit   = try(azurerm_monitor_metric_alert.availability_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    cpu_warn            = try(azurerm_monitor_metric_alert.cpu_warn[0].name, null)
    cpu_crit            = try(azurerm_monitor_metric_alert.cpu_crit[0].name, null)
    memory_warn         = try(azurerm_monitor_metric_alert.memory_warn[0].name, null)
    memory_crit         = try(azurerm_monitor_metric_alert.memory_crit[0].name, null)
    os_disk_iops_warn   = try(azurerm_monitor_metric_alert.os_disk_iops_warn[0].name, null)
    os_disk_iops_crit   = try(azurerm_monitor_metric_alert.os_disk_iops_crit[0].name, null)
    data_disk_iops_warn = try(azurerm_monitor_metric_alert.data_disk_iops_warn[0].name, null)
    data_disk_iops_crit = try(azurerm_monitor_metric_alert.data_disk_iops_crit[0].name, null)
    availability_warn   = try(azurerm_monitor_metric_alert.availability_warn[0].name, null)
    availability_crit   = try(azurerm_monitor_metric_alert.availability_crit[0].name, null)
  }
}

output "profile" {
  description = "The alert profile used"
  value       = var.profile
}

output "resolved_thresholds" {
  description = "Final threshold values after applying overrides"
  value       = local.resolved
}
```

- [ ] **Step 8: Run the tests to verify they pass**

Run: `terraform -chdir=modules/vmss test`
Expected: `Success! 9 passed, 0 failed.`

- [ ] **Step 9: Format and validate**

Run: `terraform fmt -check -recursive modules/vmss && terraform -chdir=modules/vmss validate`
Expected: no fmt output, then `Success! The configuration is valid.`

- [ ] **Step 10: Commit**

```bash
git add modules/vmss/versions.tf modules/vmss/variables.tf modules/vmss/profiles.tf modules/vmss/defaults.tf modules/vmss/main.tf modules/vmss/outputs.tf modules/vmss/tests/overrides.tftest.hcl
git commit -m "feat(vmss): add Virtual Machine Scale Set alert module"
```

### Task 2: README and examples

**Files:**
- Create: `modules/vmss/README.md`
- Create: `modules/vmss/examples/standard/main.tf`
- Create: `modules/vmss/examples/critical-with-overrides/main.tf`

**Interfaces:**
- Consumes: Task 1 module inputs and outputs (`alert_ids`, `resolved_thresholds`).
- Produces: nothing other tasks use.

- [ ] **Step 1: Write the standard example**

`modules/vmss/examples/standard/main.tf`:

```hcl
provider "azurerm" {
  features {}
}

data "azurerm_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
  resource_group_name = "rg-example"
}

data "azurerm_monitor_action_group" "critical" {
  name                = "ag-dev-critical"
  resource_group_name = "rg-monitoring-dev"
}

data "azurerm_monitor_action_group" "warning" {
  name                = "ag-dev-warning"
  resource_group_name = "rg-monitoring-dev"
}

module "vmss_alerts" {
  source = "../../"

  resource_id         = data.azurerm_virtual_machine_scale_set.example.id
  resource_name       = "dev-vmss-01"
  resource_group_name = "rg-monitoring-dev"
  profile             = "standard"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  tags = {
    environment = "development"
  }
}

output "alert_ids" {
  value = module.vmss_alerts.alert_ids
}
```

- [ ] **Step 2: Write the critical-with-overrides example**

`modules/vmss/examples/critical-with-overrides/main.tf`:

```hcl
provider "azurerm" {
  features {}
}

data "azurerm_virtual_machine_scale_set" "critical" {
  name                = "prod-vmss"
  resource_group_name = "rg-production"
}

data "azurerm_monitor_action_group" "critical" {
  name                = "ag-prod-critical"
  resource_group_name = "rg-monitoring-prod"
}

data "azurerm_monitor_action_group" "warning" {
  name                = "ag-prod-warning"
  resource_group_name = "rg-monitoring-prod"
}

module "vmss_alerts" {
  source = "../../"

  resource_id         = data.azurerm_virtual_machine_scale_set.critical.id
  resource_name       = "prod-vmss-01"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  overrides = {
    # Batch workload: sustained high CPU is expected
    cpu = {
      warning_threshold  = 90
      critical_threshold = 98
    }
    # No data disks attached
    data_disk_iops = {
      enabled = false
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.vmss_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.vmss_alerts.resolved_thresholds
}
```

- [ ] **Step 3: Validate both examples**

CI skips `examples/`, so this check is manual.

Run:
```bash
for e in standard critical-with-overrides; do
  terraform -chdir=modules/vmss/examples/$e init -backend=false -input=false >/dev/null && terraform -chdir=modules/vmss/examples/$e validate
done
```
Expected: `Success! The configuration is valid.` twice. If `azurerm_virtual_machine_scale_set` is reported as an unsupported data source, stop and report back: do not switch to another data source without asking.

- [ ] **Step 4: Write the README**

`modules/vmss/README.md`:

```markdown
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
```

- [ ] **Step 5: Format check and commit**

Run: `terraform fmt -check -recursive modules/vmss`
Expected: no output.

```bash
git add modules/vmss/README.md modules/vmss/examples
git commit -m "docs(vmss): add module README and examples"
```

### Task 3: Docs, thresholds generator, template check

**Files:**
- Modify: `scripts/gen-thresholds.py` (the `TITLES` dict)
- Modify (generated): `docs/thresholds.md`
- Modify: `docs/modules.md`
- Modify: `docs/subscription-template.md`
- Modify: `docs/contributing.md`
- Modify: `docs/concepts.md`
- Modify: `README.md`

**Interfaces:**
- Consumes: Task 1 files (`profiles.tf`, `defaults.tf`, `main.tf`) as generator input.
- Produces: nothing other tasks use.

- [ ] **Step 1: Verify the generator fails without the new title**

Run: `python3 scripts/gen-thresholds.py`
Expected: exits with `add a display name to TITLES for: vmss` and does not write the file. (Needs `pip install python-hcl2` if missing.)

- [ ] **Step 2: Add the title**

In `scripts/gen-thresholds.py`, in `TITLES`, after the `"vm": "Virtual Machine",` entry add:

```python
    "vmss": "Virtual Machine Scale Set",
```

- [ ] **Step 3: Regenerate and check the vmss table**

Run: `python3 scripts/gen-thresholds.py && grep -A9 '^### Virtual Machine Scale Set' docs/thresholds.md`
Expected: `wrote 22 module tables to docs/thresholds.md`, then:

```text
### Virtual Machine Scale Set (`vmss`)

Namespace: `Microsoft.Compute/virtualMachineScaleSets`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `cpu` | `cpu` | Percentage CPU | Average | > | 5 | 85 / 95 | 75 / 90 |
| `memory` | `memory` | Available Memory Percentage | Average | < | 5 | 15 / 10 | 20 / 15 |
| `os_disk_iops` | `osdiskiops` | OS Disk IOPS Consumed Percentage | Average | > | 5 | 85 / 95 | 75 / 90 |
| `data_disk_iops` | `datadiskiops` | Data Disk IOPS Consumed Percentage | Average | > | 5 | 85 / 95 | 75 / 90 |
| `availability` | `availability` | VmAvailabilityMetric | Average | < | 5 | 1 / 0.5 | 1 / 0.75 |
```

Also run `git diff --stat docs/thresholds.md`: only additions (the new section), no changed lines in other modules' tables.

- [ ] **Step 4: Update `docs/modules.md`**

Replace `PANIC has 21 resource modules` with `PANIC has 22 resource modules`.

After the `| Virtual Machine | [`vm`]...` row, insert:

```markdown
| Virtual Machine Scale Set | [`vmss`](../modules/vmss/) | `Microsoft.Compute/virtualMachineScaleSets` | 5 of 5 | [thresholds](thresholds.md#virtual-machine-scale-set-vmss) |
```

Delete the final paragraph that starts with `Not covered yet: Virtual Machine Scale Sets.` (and the blank line before it, so the file ends after the examples list).

- [ ] **Step 5: Update `docs/subscription-template.md`**

Delete the whole `## Known issue` section (the heading and its paragraph about `vmss.tf`) and the blank line before it.

- [ ] **Step 6: Update `docs/contributing.md`**

- In the module-style table header, replace `| The other 17 |` with `| The other 18 |`.
- In "Known inconsistencies", replace this line:

  ```markdown
  - Modules declare `terraform >= 1.0`, but `optional()` in `overrides` needs 1.3.
  ```

  with:

  ```markdown
  - Most modules declare `terraform >= 1.0`, but `optional()` in `overrides` needs 1.3.
  ```

- In "Known inconsistencies", delete this line:

  ```markdown
  - `templates/panic-subscription-template/vmss.tf` references a module that doesn't exist.
  ```

- [ ] **Step 7: Update `docs/concepts.md` and `README.md`**

- `docs/concepts.md`: replace `The other 17 modules were never affected.` with `The other modules were never affected.`
- `README.md`: replace `- 21 resource modules,` with `- 22 resource modules,`

- [ ] **Step 8: Check docs for leftovers and broken links**

Run:
```bash
grep -rn "21 resource\|other 17\|Not covered yet\|Known issue" README.md docs/*.md
python3 - <<'EOF'
import re, os, glob
def slug(h): return re.sub(r'[^\w\- ]', '', h.strip().lower()).replace(' ', '-')
def anchors(p): return {slug(m.replace('`', '')) for m in re.findall(r'^#+ (.*)$', open(p).read(), re.M)}
bad = 0
for f in ['README.md', 'modules/vmss/README.md'] + glob.glob('docs/*.md'):
    txt = re.sub(r'```.*?```', '', open(f).read(), flags=re.S)
    for link in re.findall(r'\]\(([^)]+)\)', txt):
        if link.startswith('http'): continue
        path, _, anc = link.partition('#')
        tgt = os.path.normpath(os.path.join(os.path.dirname(f), path)) if path else f
        if not os.path.exists(tgt): print('MISSING', f, link); bad += 1; continue
        if anc and tgt.endswith('.md') and anc not in anchors(tgt): print('ANCHOR', f, link); bad += 1
print('bad', bad)
EOF
```
Expected: the `grep` prints nothing; the script prints `bad 0`.

- [ ] **Step 9: Check the template against the local module**

The real tag doesn't exist before merge, so point a scratch copy's `vmss.tf` at the local module:

```bash
T=$(mktemp -d)
cp -r templates/panic-subscription-template/. "$T"
sed -i "s#git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vmss?ref=vmss/v1.0.0#$PWD/modules/vmss#" "$T/vmss.tf"
grep source "$T/vmss.tf"
terraform -chdir="$T" init -backend=false -input=false >/dev/null && terraform -chdir="$T" validate
rm -rf "$T"
```
Expected: the `source` line shows the local path; `Success! The configuration is valid.`

- [ ] **Step 10: Commit**

```bash
git add scripts/gen-thresholds.py docs/thresholds.md docs/modules.md docs/subscription-template.md docs/contributing.md docs/concepts.md README.md
git commit -m "docs: add vmss module to docs and thresholds"
```

---

## After implementation (main session, not an implementer task)

1. Push `feat/vmss-module` and open the PR. Paste the outputs of Task 1 Step 8, Task 2 Step 3 and Task 3 Step 9 into the PR description (CI doesn't run them).
2. After merge: tag `vmss/v1.0.0` on the merge commit and push it immediately (ask the user first).
3. Verify: `terraform init` + `validate` on an unmodified copy of `templates/panic-subscription-template/`.
4. When a Flexible-orchestration scale set is available, check in the portal that all five metrics have data at scale-set scope.
