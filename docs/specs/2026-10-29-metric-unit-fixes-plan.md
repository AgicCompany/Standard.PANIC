---
title: Metric unit fixes plan (issues #17, #18, #21)
date: 2026-10-29
status: draft
version: 0.2
author_model: claude-sonnet-5.5
---

# Metric unit fixes plan

Covers #17, #18 and #21 (children of umbrella #13). Three independent branches, one PR each. Order: #17 (smallest), #21, #18.

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

Do not code from memory. For each metric, read Microsoft Learn "supported metrics" for the namespace and record unit and name in the PR.

1. `Microsoft.App/containerApps`: is there a percentage CPU/memory metric? If yes, switch to it. If not, disable cpu/memory by default or use realistic raw defaults.
2. `Microsoft.Web/sites` (function): percentage memory metric, or only bytes?
3. `Microsoft.Compute/disks`: which metrics exist (e.g. IOPS/bandwidth consumed percentage at disk level)? Does queue depth exist? If not, remove `queue_depth`, `burst_*`.
4. `Microsoft.Network/virtualNetworkGateways`: is there a tunnel status metric (e.g. `TunnelIngressBytes`, `TunnelPeakPackets`, or a gateway/tunnel state metric)? Pick the right one or remove `tunnel_status`.
5. Azure Firewall: `Throughput` unit (bits/s). Any percent metric? `SNATPortUtilization` is already a percent.
6. Redis `connectedclients`, MySQL `active_connections`, SQL MI `io_requests`/`io_bytes_read`: raw only? Any percentage metric?
7. Load balancer `UsedSnatPorts` / `SnatConnectionCount`: raw counts per backend; no percent.

## Decision rule (propose, needs approval)

For a raw metric with no percentage alternative, use one of:

- **A. Disable by default** (`enabled = false`), keep a sane placeholder, document "set thresholds in raw units via overrides". Matches what disk, sqlmi `storage`, and vpngw `p2s_*` already do.
- **B. Realistic raw default** only when a universal value exists (e.g. DropCount style counts).

Default: A for every metric that depends on SKU size (bandwidth, memory, capacity, connections). Change the profile comment to state the unit. This is a default-behavior change (alerts removed on upgrade), so each module is a **minor** bump per the earlier decision; call it out in the PR.

## Task 1: disk (#17) - branch `fix/disk-metrics`

- Per question 3: fix the `queue_depth` name (or point it at a real metric if one exists). Keep `queue_depth` and `burst_*` as disabled variables; do not remove them. Minor bump (`disk/v2.2.0` or next).
- Fix `iops_consumed` / `bandwidth_consumed` thresholds to raw-unit placeholders, or switch to a percent metric if one exists.
- Update `modules/disk/README.md`, `docs/modules.md` count, run `python3 scripts/gen-thresholds.py`.
- Test: extend `modules/disk/tests/` so no two metrics share a `name`.

## Task 2: containerapp, function, storage, servicebus (#21) - branch `fix/byte-metrics`

- containerapp `cpu`, `memory`; function `memory`; servicebus `size`; storage `used_capacity`: apply the decision rule (percent metric if question 1/2 finds one, otherwise disable by default).
- Update 4 READMEs, regenerate `docs/thresholds.md`.
- Test per module: assert the default-enabled metrics do not use a byte/nanocore metric (check `local.metrics.*.name` or `enabled` in the plan output).
- Release 4 module tags, then bump 4 template `?ref=`.

## Task 3: network and db (#18) - branch `fix/network-db-metrics`

- `lb`: store `100` in `profiles.tf` (both profiles), remove `* 100` in `main.tf:19`. Check `tests/overrides.tftest.hcl` for `health_probe_status` expectations. Breaking for anyone who overrode this field with the old scale, so note it in the PR.
- `vpngw`: fix `tunnel_status` metric (question 4) in addition to the issue scope. Disable `tunnel_bandwidth` by default.
- `expressroute`, `firewall`, `lb` (snat), `redis`, `mysql`, `sqlmi`: apply the decision rule.
- Update 7 READMEs, regenerate `docs/thresholds.md`.
- Release 7 module tags, then bump 7 template `?ref=`.

## Verification (every task)

- `terraform fmt -check -recursive`
- For each touched module and its `examples/*`: `terraform -chdir=<dir> init -backend=false && terraform -chdir=<dir> validate`
- `terraform -chdir=modules/<m> test` for each touched module (all have tests/).
- `python3 scripts/gen-thresholds.py` and `git diff --exit-code docs/thresholds.md` (CI checks drift).
- Tag order: merge PR, tag modules, then bump template `?ref=` (CI fails other PRs until the template matches the highest tag). Template bump needs the user's OK to push, like everything else.
- No `apply` or `az` calls needed. Doc checks use Microsoft Learn only.

## Decisions (approved 2026-10-29)

1. **Standard fix:** switch to a percentage metric where Azure Monitor has one (verified on Microsoft Learn). Otherwise disable by default (rule A) and document raw-unit overrides. No guessed raw defaults, because the right value depends on SKU size.
2. **disk:** keep `queue_depth` and `burst_*` as disabled variables, fix the duplicate name and comments. Minor bump, no `overrides` type change.
3. **vpngw `tunnel_status`:** added to #18 scope.
4. **Stale issue text:** post a correction comment on #17 and #18 (bodies not edited).
