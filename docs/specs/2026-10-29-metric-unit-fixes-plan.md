---
title: Metric unit fixes plan (issues #17, #18, #21)
date: 2026-10-29
status: implemented
version: 0.5
author_model: claude-sonnet-5.5
---

# Metric unit fixes plan

Covers #17, #18 and #21 (children of umbrella #13). Three independent branches, one module PR each, plus one follow-up template-ref PR per task. Order: #17 (smallest), #21, #18.

## Findings (verified in the repo at 38222af)

The issues are partly stale. Earlier work already disabled some of the bad alerts.

- **disk (#17):** all 5 metrics are `enabled = false` in both profiles. `queue_depth` still has `name = "Composite Disk Read Operations/sec"` (duplicate of `iops_consumed`). `burst_*` use names that are not disk metrics. `iops_consumed` / `bandwidth_consumed` keep 85/95 thresholds on raw rates. `docs/modules.md` shows "0 of 5" enabled.
- **containerapp (#21):** `cpu` (`UsageNanoCores`) and `memory` (`WorkingSetBytes`) are enabled with 70/90 and 60/80. Real bug.
- **function (#21):** `memory` (`MemoryWorkingSet`, bytes) is enabled with 80/95 and 70/90. Real bug.
- **storage (#21):** `used_capacity` (`UsedCapacity`, bytes) with 80/90 and 70/85. Enabled: `defaults.tf:68` defaults `enabled` to `true` (storage has no per-profile `enabled`). Real bug.
- **servicebus (#21):** `size` (`Size`, bytes) is enabled with 80/95 and 70/85. Real bug.
- **vpngw (#18, not in the issue):** `tunnel_status` uses `TunnelAverageBandwidth`, the same metric as `tunnel_bandwidth`. It is enabled and alerts `LessThan 1`, so it fires when bandwidth is below 1 Bps. Real bug, same class as #17.
- **expressroute, firewall (#18):** `BitsInPerSecond` / `BitsOutPerSecond` / `Throughput` are enabled with 70-95 thresholds. Real bug (raw bits/sec).
- **vpngw (#18):** `tunnel_bandwidth` is enabled (bytes/sec, 70-95). `p2s_*` are disabled.
- **lb (#18):** `snat_connection_count` and `used_snat_ports` are enabled with 70-95. `health_probe_status` has `critical_threshold = 1` and `main.tf:19` multiplies by 100.
- **redis (#18):** `connected_clients` is **enabled** (issue says disabled) with 80/95 and 70/90, metric `connectedclients` is a raw count.
- **mysql (#18):** `connections` is **enabled** (issue says disabled) with 80/95 and 70/90, metric `active_connections` is a raw count.
- **sqlmi (#18):** `io_requests` and `io_bytes` are **enabled** (issue says disabled) with 70-95, metrics are raw counts/bytes. `storage` is already disabled.

## Open questions (need Azure Monitor doc checks before coding)

Done in the section above; do not code from memory for anything new. For each metric, read Microsoft Learn "supported metrics" for the namespace and record unit and name in the PR.

1. `Microsoft.App/containerApps`: is there a percentage CPU/memory metric? If yes, switch to it. If not, disable cpu/memory by default.
2. `Microsoft.Web/sites` (function): percentage memory metric, or only bytes?
3. `Microsoft.Compute/disks`: which metrics exist (e.g. IOPS/bandwidth consumed percentage at disk level)? Does queue depth exist? If not, remove `queue_depth`, `burst_*`.
4. `Microsoft.Network/virtualNetworkGateways`: is there a tunnel status metric (e.g. `TunnelIngressBytes`, `TunnelPeakPackets`, or a gateway/tunnel state metric)? Pick the right one or remove `tunnel_status`.
5. Azure Firewall: `Throughput` unit (bits/s). Any percent metric? `SNATPortUtilization` is already a percent.
6. Redis `connectedclients`, MySQL `active_connections`, SQL MI `io_requests`/`io_bytes_read`: raw only? Any percentage metric?
7. Load balancer `UsedSnatPorts` / `SnatConnectionCount`: raw counts per backend; no percent.

## Metric verification (Microsoft Learn, checked 2026-10-29)

Source pages: `https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/<microsoft-...-metrics>` for each namespace.

| Module | Result | Action |
|---|---|---|
| containerapp | `CpuPercentage`, `MemoryPercentage` exist (Percent, Avg/Max/Min/Total, preview, "percent of limit") | Switch `cpu`, `memory` to them; keep 70/90 and 60/80, Average |
| function | `Microsoft.Web/sites` has only `MemoryWorkingSet`/`AverageMemoryWorkingSet` (Bytes) | Disable `memory` by default |
| servicebus | `Size` is Bytes; `NamespaceMemoryUsage` (Percent) is memory, not entity size | Disable `size` by default |
| storage | `UsedCapacity` Bytes, no percent | Disable `used_capacity` by default |
| disk | `Microsoft.Compute/disks` lists only 4 Composite metrics (raw rates) plus `DiskPaidBurstIOPS`; no queue depth, no burst credits, no percent | Keep all disabled; give `queue_depth` a non-duplicate name (see Task 1) |
| vpngw | no tunnel state metric; `TunnelAverageBandwidth`, `P2SBandwidth` are BytesPerSecond, `P2SConnectionCount` Count | Disable `tunnel_bandwidth`; `tunnel_status` disabled and re-pointed (see Task 3) |
| expressroute | `IngressBandwidthUtilization`, `EgressBandwidthUtilization` exist (Percent, Maximum aggregation, dims PeeringType/DeviceRole, category Circuit Traffic) | Switch `bits_in`, `bits_out` to them with Maximum |
| firewall | `Throughput` is BitsPerSecond, no percent. Also: latency metric is `FirewallLatencyPng`, defaults use `FirewallLatencyProbe` (invalid name) | Disable `throughput`; fix latency name (extra bug found, in #18 scope) |
| lb | `SnatConnectionCount`, `UsedSnatPorts` are Count; no percent | Disable both |
| redis | `connectedclients` Count; `usedmemorypercentage`, `serverLoad`, `cachemissrate` are Percent | Disable `connected_clients` |
| mysql | `active_connections` Count; no percent | Disable `connections` |
| sqlmi | `io_requests` Count, `io_bytes_read` Bytes | Disable `io_requests`, `io_bytes` |

## Decision rule (approved)

1. Percentage metric where Microsoft Learn lists one **and** it measures the intended condition (record URL, metric name, unit, aggregation, applicability limits in the PR).
2. Otherwise `enabled = false` by default. Keep a placeholder threshold with the unit in the comment; users enable it and set raw-unit thresholds via `overrides`. No guessed raw defaults.
3. Unsupported metric names (no valid metric exists): keep the variable (approved), keep it disabled, comment says "not available on <namespace>". Same pattern disk uses today. The name must still not duplicate another metric. Enabling it via override will fail at apply for an invalid name; document that in the README. For vpngw `tunnel_status`: use a real tunnel state metric if question 4 finds one, else disable and document.

## Release policy

`docs/versioning.md` says changed defaults are **major**. Therefore:

- **Major bump** for modules where an enabled default becomes disabled or the metric/threshold changes: containerapp, function, servicebus, storage, expressroute, firewall, vpngw, lb, redis, mysql, sqlmi.
- **Minor bump** for disk only (approved): all alerts already disabled, only a name/comment fix, no behavior change.
- **lb** also changes the scale of `health_probe_status.critical_threshold` (1 -> 100): major, and the README needs a migration note ("if you overrode this field, divide by 100 -> use percent").
- Add migration notes to each module README and add a short entry to `docs/versioning.md` if it lists per-module notes. Update the policy table text if a major for "alerts disabled by default" needs clarifying (it already matches the `disk v2.0.0` precedent).

## Task 1: disk (#17) - branch `fix/disk-metrics`

- Per question 3: fix the `queue_depth` name (or point it at a real metric if one exists). Keep `queue_depth` and `burst_*` as disabled variables; do not remove them. Minor bump (`disk/v2.2.0` or next).
- Switch to a percent metric if one exists; otherwise keep disabled with a placeholder threshold and unit in the comment.
- Update `modules/disk/README.md`, `docs/modules.md` count, run `python3 scripts/gen-thresholds.py`.
- Test: extend `modules/disk/tests/` so no two metrics share a `name`; every metric stays disabled by default in both profiles.

## Task 2: containerapp, function, storage, servicebus (#21) - branch `fix/byte-metrics`

- containerapp `cpu`, `memory`; function `memory`; servicebus `size`; storage `used_capacity`: apply the decision rule (percent metric if question 1/2 finds one, otherwise disable by default).
- Update 4 READMEs, regenerate `docs/thresholds.md`.
- Tests per module, both profiles: default-enabled metrics are only percent/count-safe ones (assert `local.metrics.*.name` and enabled flags via `output.resolved_thresholds`); a replacement percent metric has correct unit thresholds; explicit `enabled = true` plus raw thresholds creates alerts with the raw value. Fix existing tests that assume disabled metrics are created after a threshold-only override (e.g. `containerapp/tests/overrides.tftest.hcl` `partial_override_keeps_profile_defaults` expects cpu alerts).
- Update `docs/modules.md` enabled counts. Check `examples/*` for overrides that assume the alert is enabled.
- Release 4 module tags (major), then bump 4 template `?ref=` in a follow-up PR.

## Task 3: network and db (#18) - branch `fix/network-db-metrics`

- `lb`: store `100` in `profiles.tf` (both profiles), remove `* 100` in `main.tf:19`. Check `tests/overrides.tftest.hcl` for `health_probe_status` expectations. Breaking for anyone who overrode this field with the old scale, so note it in the PR.
- `vpngw`: fix `tunnel_status` metric (question 4) in addition to the issue scope. Disable `tunnel_bandwidth` by default.
- `expressroute`, `firewall`, `lb` (snat), `redis`, `mysql`, `sqlmi`: apply the decision rule.
- Update 7 READMEs, `docs/modules.md` counts, regenerate `docs/thresholds.md`.
- Tests: lb default `health_probe_status` threshold is `100` in the planned alert, and an override (e.g. 50) is passed through unscaled; changed default enablement and any replacement metric asserted per module; fix existing tests that assume old defaults.
- Release 7 module tags (major), then bump 7 template `?ref=` in a follow-up PR.

## Verification (every task)

- `terraform fmt -check -recursive`
- For each touched module and its `examples/*`: `terraform -chdir=<dir> init -backend=false && terraform -chdir=<dir> validate`
- `terraform -chdir=modules/<m> test` for each touched module (all have tests/).
- `python3 scripts/gen-thresholds.py` and `git diff --exit-code docs/thresholds.md` (CI checks drift).
- Tag order: PR 1 per task (module code + docs) merges, then tag the modules, then a **follow-up PR** bumps the template `?ref=` (disk included). CI fails other PRs between tagging and the bump, so keep the gap short. After the bump run `init -backend=false && validate` and `terraform test` on the template dir (CI does). Pushes and PRs need the user's OK.
- No `apply` or `az` calls needed. Doc checks use Microsoft Learn only.

## Decisions (approved 2026-10-29)

Note: the plan review (round 1) returned REVISE; v0.3 addresses its blockers. Release policy below needs your confirmation.

1. **Standard fix:** switch to a percentage metric where Azure Monitor has one (verified on Microsoft Learn). Otherwise disable by default (rule A) and document raw-unit overrides. No guessed raw defaults, because the right value depends on SKU size.
2. **disk:** keep `queue_depth` and `burst_*` as disabled variables, fix the duplicate name and comments. Minor bump, no `overrides` type change.
3. **vpngw `tunnel_status`:** added to #18 scope.
4. **Stale issue text:** post a correction comment on #17 and #18 (bodies not edited).
