---
title: vmss alert module
date: 2026-09-28
status: active
version: 1.1
---

# vmss alert module

## Problem

`templates/panic-subscription-template/vmss.tf` calls
`modules/vmss?ref=vmss/v1.0.0`. Neither the module nor the tag exists.
`terraform init` downloads every module source, including those behind switches
that are off, so the whole template fails to initialize.

## Goal

Add `modules/vmss`, a resource module for Virtual Machine Scale Sets. It has
the same interface as the other resource modules and is released as
`vmss/v1.0.0`. The existing `vmss.tf` then works unchanged.

Success:

1. The template initializes and validates with the unchanged `vmss.tf` once
   `vmss/v1.0.0` exists.
2. `terraform test` in `modules/vmss` covers default alerts and override
   behavior, and passes.
3. `docs/thresholds.md`, `docs/modules.md` and the README list vmss. The vmss
   known-issue notes are removed.

## Non-goals

- Per-instance alerts (splitting on the `VMName` dimension).
- Guest-OS metrics that need Azure Monitor Agent, such as logical disk free
  space. There is no platform metric for them on scale sets.
- Changing the `vm` module. Its memory metric bug (bytes metric, percent
  thresholds) is a separate change. This spec's research shows that the fix is
  the `Available Memory Percentage` platform metric.

## Metric source

All metrics are platform metrics in the `Microsoft.Compute/virtualMachineScaleSets`
namespace, from Microsoft's supported-metrics reference for that resource type.
No agent is needed. Each alert evaluates the metric across the whole scale set,
with no dimension filter or split.

Two metrics from the archived design doc (`docs/specs/2026-01-29-implementation-guide.md`,
section 8.1.1) are not used, because no such platform metric exists:

- "Logical Disk Free %" (guest metric).
- "Unhealthy Instance Count". `availability` below covers it instead.

Orchestration mode: the metrics reference lists these metrics at scale-set
scope. Microsoft documents that Flexible orchestration supports metrics-based
autoscale, which reads scale-set-level `Percentage CPU`. It doesn't confirm
the other four metrics for Flexible. Treat Flexible as expected to work, and
check it after release (see Release).

## Metrics and profiles

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `cpu` | `cpu` | Percentage CPU | Average | > | 5 | 85 / 95 | 75 / 90 |
| `memory` | `memory` | Available Memory Percentage | Average | < | 5 | 15 / 10 | 20 / 15 |
| `os_disk_iops` | `osdiskiops` | OS Disk IOPS Consumed Percentage | Average | > | 5 | 85 / 95 | 75 / 90 |
| `data_disk_iops` | `datadiskiops` | Data Disk IOPS Consumed Percentage | Average | > | 5 | 85 / 95 | 75 / 90 |
| `availability` | `availability` | VmAvailabilityMetric | Average | < | 5 | 1 / 0.5 | 1 / 0.75 |

- All five metrics are enabled in both profiles.
- `availability` is the scale-set average of `VmAvailabilityMetric`: 1.0 means
  every instance is available. The warning fires when any instance is
  unavailable. The critical alert fires when more than half of the instances
  (`standard`) or more than a quarter (`critical`) are unavailable.
- Alert descriptions follow the operator: "exceeded X" for `>` and "below X"
  for `<`. Percent metrics show `%`; `availability` is a fraction, so no `%`.
- CPU uses Average across instances because that's the signal autoscale acts
  on. To alert on a single hot instance, use `modules/base` with Maximum.
- Scale sets without data disks publish no `data_disk_iops` data. The alert
  exists but never fires. That's accepted: disabling it by default would hide
  the metric from scale sets that do have data disks.

## Module layout

`modules/vmss/` follows the newer module style, the same as `aks`:

| File | Contents |
|------|----------|
| `profiles.tf` | `local.profiles.standard` and `.critical`, each metric with `enabled`, `warning_threshold`, `critical_threshold`, `window_minutes` |
| `defaults.tf` | `local.metric_namespace`, `local.metrics` (name, aggregation, operator, description), `local.selected_profile`, `local.resolved`, `local.common_tags` |
| `variables.tf` | `resource_id`, `resource_name`, `resource_group_name`, `action_group_ids`, `profile` (default `standard`, validated), `enabled` (default `true`), `tags` (default `{}`), `overrides` (typed object, one `optional(object)` per metric with the four optional fields) |
| `main.tf` | `<metric>_warn` and `<metric>_crit` `azurerm_monitor_metric_alert` per metric; severity 2 / 1; frequency `PT1M`; `auto_mitigate = true`; `count = var.enabled && local.resolved.<metric>.enabled ? 1 : 0`; name `${var.resource_name}-<suffix>-{warn,crit}` |
| `outputs.tf` | `alert_ids`, `alert_names`, `profile`, `resolved_thresholds` |
| `versions.tf` | `required_version = ">= 1.3"` (needed for `optional()`), `azurerm >= 3.0` |
| `README.md` | Same sections as other module READMEs |
| `examples/standard/`, `examples/critical-with-overrides/` | Use `data "azurerm_virtual_machine_scale_set"`, which exists in the provider |
| `tests/overrides.tftest.hcl` | See Testing |

Override merge, for every field:

```hcl
coalesce(try(var.overrides.<metric>.<field>, null), local.selected_profile.<metric>.<field>)
```

`local.common_tags = merge(var.tags, { managed-by = "terraform" })`, matching
the other 11 modules in this style that use `common_tags`. No `module-version`
tag.

## Testing

`modules/vmss/tests/overrides.tftest.hcl`, with `mock_provider "azurerm" {}` and
`command = plan`:

1. Defaults: all 10 alerts are created, and `resolved_thresholds` matches the
   `standard` row of the table.
2. `profile = "critical"`: `resolved_thresholds.availability.critical_threshold == 0.75`.
3. Partial override: `cpu = { warning_threshold = 90 }` keeps both CPU alerts,
   and keeps `critical_threshold = 95` and `window_minutes = 5`.
4. `cpu = { enabled = false }` removes both CPU alerts.
5. Module `enabled = false` creates no alerts.
6. `overrides = null` creates all 10 alerts. This is what the template passes
   for an entry without overrides, because its `overrides` is
   `optional(map(any))`.
7. String-typed overrides:
   `{ cpu = { warning_threshold = "90" }, memory = { enabled = "false" } }`
   gives `cpu.warning_threshold == 90` and no memory alerts. This guards type
   conversion only. The template's `map(any)` does **not** turn mixed override
   objects into strings, as v1.0 of this spec assumed: it rejects them before
   they reach the module (see Known limitation).

CI runs `fmt` and `validate` on the module only. It doesn't run
`terraform test`, and skips `examples/` and `templates/`. The checks below are
manual; paste their output into the PR description. `mock_provider` needs
Terraform 1.7 or later to run the tests (CI uses 1.15.2), though the module
itself declares `>= 1.3`.

- `terraform fmt -check -recursive` and `validate` pass for the module and
  both examples.
- A scratch copy of the template, with `vmss.tf` pointed at the local module,
  passes `init` and `validate`. The real tag can't exist before merge.

## Docs

- `scripts/gen-thresholds.py`: add `"vmss": "Virtual Machine Scale Set"` to
  `TITLES`, then regenerate `docs/thresholds.md`.
- `docs/modules.md`: add the vmss row. Change "21 resource modules" to 22.
  Remove the "Not covered yet: Virtual Machine Scale Sets" note.
- `docs/subscription-template.md`: remove the "Known issue" section.
- `docs/contributing.md`: remove the `vmss.tf` known-inconsistency line.
- `README.md`: "21 resource modules" becomes 22.
- `docs/contributing.md`: "The other 17" becomes "The other 18" (module-style
  table), and the known-inconsistency line "Modules declare `terraform >= 1.0`"
  becomes "Most modules declare `terraform >= 1.0`".
- `docs/concepts.md`: "The other 17 modules were never affected" becomes
  "The other modules were never affected".
- `docs/versioning.md`: no change. "Every module is at `v1.0.0` except the
  four at `v1.0.1`" already covers vmss.

## Release

1. Merge the PR.
2. Tag `vmss/v1.0.0` on the merge commit and push it right after the merge.
   Until the tag exists, the docs no longer mention the known issue, but the
   template still fails `init`.
3. No template change is needed: `vmss.tf` already references `vmss/v1.0.0`.
4. Verify: `terraform init` + `validate` on an unmodified copy of the template.
5. When a Flexible-orchestration scale set is available, check in the portal
   that all five metrics have data at scale-set scope. If some don't, record it
   in the module README as a limitation.

Between merge and tag, `main` still has a template that fails `init`. That's the
same state as today, so there's no regression.

## Known limitation (found in final review)

The template declares `overrides = optional(map(any))` for every resource type.
`map(any)` requires one common element type, so these fail at plan with
"all map elements must have the same type" or "attribute types must all match":

- one entry whose override objects have different shapes, such as
  `cpu = { warning_threshold = 95 }` and `memory = { enabled = false }`
- an entry with overrides next to an entry without them

This affects all resource types and predates this module. It is out of scope
here (no template changes) and is fixed in a separate change.

## Review log

- v0.2: independent spec review (plan-verifier) returned READY with
  non-blocking findings only. They are applied here, with no further review
  round.
- v1.1: final code review found that the template's `map(any)` rejects mixed
  override shapes (not introduced here). Test 7 wording corrected; limitation
  recorded; template fix split into its own change.
