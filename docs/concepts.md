---
title: Concepts
date: 2026-09-28
status: draft
version: 0.1
---

# Concepts

## Deployment model

PANIC alerts are a separate layer from the resources they watch. You deploy them from their own Terraform root, with their own state, and pass in resource IDs. The team that owns a database doesn't have to own its alerts, and removing all alerts never touches a resource.

```
your resources  --resource_id-->  PANIC module  --creates-->  azurerm_monitor_metric_alert (warn + crit per metric)
```

## Profiles

Every resource module takes `profile = "standard"` or `profile = "critical"`.

| Profile | Use for | Effect |
|---------|---------|--------|
| `standard` | Most workloads, non-production | Looser thresholds |
| `critical` | Business-critical production | Tighter thresholds, so alerts fire earlier |

A profile sets, per metric: whether the metric is enabled, the warning threshold, the critical threshold, and the evaluation window. Both profiles use the same severities. For typical utilization metrics, `standard` warns around 80-85% and goes critical around 95%; `critical` warns around 70-75% and goes critical around 90%. The exact numbers are in [Thresholds](thresholds.md).

Some metrics are off in both profiles. They either need extra setup (VM guest metrics need Azure Monitor Agent) or have no sensible default (request counts depend on the workload). Turn them on with an override.

## Overrides

`overrides` changes individual settings for individual metrics. Anything you don't override keeps the profile value.

```hcl
# modules/sqldb
overrides = {
  cpu = {
    warning_threshold  = 90
    critical_threshold = 98
  }
  dtu = {
    enabled = false         # vCore database: no DTU metric
  }
  storage = {
    window_minutes = 30     # look at a longer window
  }
}
```

Each metric accepts exactly these fields:

| Field | Type | Meaning |
|-------|------|---------|
| `enabled` | bool | Create this metric's alerts or not |
| `warning_threshold` | number | Threshold for the warning alert |
| `critical_threshold` | number | Threshold for the critical alert |
| `window_minutes` | number | Evaluation window |

Severity, aggregation, operator and frequency are fixed per module and can't be overridden.

The metric keys (`cpu`, `data_disk_iops`, ...) differ per module. Look them up in the "Override key" column of [Thresholds](thresholds.md). A key that isn't in the module's list is silently ignored, so check the spelling.

A few metrics only have a critical alert, for example VM `availability` and App Service `health_check`. For those, only `critical_threshold` matters.

> **On `v1.0.0` of `vm`, `storage`, `appservice` or `postgresql`:** a partial override silently disables that metric. For example, `cpu = { warning_threshold = 90 }` removes the CPU alerts. Upgrade to `v1.0.1`, or set all four fields when you override a metric. The other 17 modules were never affected.

To turn off every alert from a module without removing it, set `enabled = false` on the module.

## What each alert looks like

For each enabled metric, a module creates two `azurerm_monitor_metric_alert` resources:

| | Warning | Critical |
|---|---------|----------|
| Severity | 2 | 1 |
| Action group | `action_group_ids.warning` | `action_group_ids.critical` |
| Name | `{resource_name}-{suffix}-warn` | `{resource_name}-{suffix}-crit` |

All alerts evaluate every minute over the metric's window, and resolve themselves when the condition clears (`auto_mitigate = true`). An alert fires as soon as one window breaches the threshold. There's no "N of M periods" logic.

The `{suffix}` is a short name per metric, such as `cpu`, `nodecpu` or `snat-util`. It isn't always the same as the override key. [Thresholds](thresholds.md) lists both.

## Common inputs and outputs

Every resource module has the same interface.

| Input | Required | Description |
|-------|----------|-------------|
| `resource_id` | yes | ID of the Azure resource to monitor |
| `resource_name` | yes | Prefix for alert rule names |
| `resource_group_name` | yes | Resource group the alert rules are created in |
| `action_group_ids` | yes | `{ critical = "...", warning = "..." }` |
| `profile` | no | `standard` (default) or `critical` |
| `overrides` | no | See above |
| `enabled` | no | `false` disables all alerts from this module. Default `true` |
| `tags` | no | Extra tags for every alert rule |

| Output | Description |
|--------|-------------|
| `alert_ids` | Map of created alert rule IDs |
| `alert_names` | Map of created alert rule names |
| `profile` | Profile in use |
| `resolved_thresholds` | Final per-metric settings after overrides. Useful in `terraform console` to check what you'll get |

Every alert rule gets the tag `managed-by = terraform`, plus your `tags`.

## The base module

`modules/base` creates one metric alert from raw inputs: metric namespace, metric name, operator, threshold, severity, one action group. It has no profiles. Use it for a metric that no resource module covers. The resource modules don't use it internally.

## Suggested conventions

These aren't enforced by the modules, but the examples and templates follow them:

- One monitoring resource group per environment, such as `rg-monitoring-prod` and `rg-monitoring-dev`.
- Action groups named `ag-{environment}-{critical|warning}`.
- `resource_name` equal to the monitored resource's own name, so alert names read naturally.
