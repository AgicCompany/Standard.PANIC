---
title: Versioning
date: 2026-10-29
status: active
version: 0.2
---

# Versioning

Each module has its own version. Tags use the form `<module>/v<semver>`, for example `vm/v1.0.1` or a hypothetical future `storage/v1.2.0`. Upgrading `vm` never forces a change to `storage`.

## Pinning a module

```hcl
source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vm?ref=vm/v1.2.0"
#         └─ repository                                        └─ folder  └─ tag
```

The `//` separates the repository from the folder inside it. Terraform clones the repository at the tag and uses that folder as the module.

Always pin to a full tag. Never use:

- `?ref=main`, which changes under you.
- No `?ref` at all, which means the default branch.

## Current versions

Every module is at `v1.0.0`, except:

| Module | Version | Change |
|--------|---------|--------|
| `appservice`, `postgresql`, `storage` | `v1.0.1` | Partial overrides no longer silently disable a metric; see [Concepts](concepts.md#overrides) |
| `vm` | `v1.1.0` | `v1.0.1` fix, plus the memory alert uses `Available Memory Percentage` |
| `sqlmi` | `v2.0.0` | Storage alert off by default: it is a raw MB metric |
| `disk` | `v2.0.0` | All alerts off by default: managed disks only expose raw rate metrics |

To list tags:

```bash
git ls-remote --tags https://github.com/AgicCompany/Standard.PANIC.git
```

## Pending major releases (unreleased)

These changes require major releases. No new tags or template source refs are included in this change.

| Module | Change | Migration |
|--------|--------|-----------|
| `expressroute` | Bandwidth alerts use link utilization percentages with Maximum aggregation | Convert raw bits/sec overrides to percentages; see [migration notes](../modules/expressroute/README.md#migration-next-major-release-unreleased) |
| `firewall` | Throughput alerts disabled by default; latency metric name corrected | Explicitly enable throughput with raw bits/sec thresholds; see [migration notes](../modules/firewall/README.md#migration-next-major-release-unreleased) |
| `lb` | SNAT alerts disabled by default; health probe overrides use percent directly | Enable SNAT with raw counts and convert health probe overrides from 0-1 to percent; see [migration notes](../modules/lb/README.md#migration-next-major-release-unreleased) |
| `mysql` | Active connection alerts disabled by default | Explicitly enable with raw count thresholds; see [migration notes](../modules/mysql/README.md#migration-next-major-release-unreleased) |
| `redis` | Connected client alerts disabled by default | Explicitly enable with raw count thresholds; see [migration notes](../modules/redis/README.md#migration-next-major-release-unreleased) |
| `sqlmi` | IO request and byte alerts disabled by default | Explicitly enable with raw count/byte thresholds; see [migration notes](../modules/sqlmi/README.md#migration-next-major-release-unreleased) |
| `vpngw` | Tunnel bandwidth and status alerts disabled; status uses inbound packets, not bandwidth | Set raw Bytes/sec thresholds; opt in to idle-tunnel packet alerts only if wanted; see [migration notes](../modules/vpngw/README.md#migration-next-major-release-unreleased) |
| `containerapp` | CPU and memory use preview percentage-of-limit metrics instead of nanocores/bytes | Convert raw-unit overrides to percentages; see [migration notes](../modules/containerapp/README.md#migration-next-major-release-unreleased) |
| `function` | Memory alerts disabled by default | Explicitly enable with raw byte thresholds; see [migration notes](../modules/function/README.md#migration-next-major-release-unreleased) |
| `servicebus` | Size alerts disabled by default | Explicitly enable with raw byte thresholds; see [migration notes](../modules/servicebus/README.md#migration-next-major-release-unreleased) |
| `storage` | Used capacity alerts disabled by default | Explicitly enable with raw byte thresholds; see [migration notes](../modules/storage/README.md#migration-next-major-release-unreleased) |

## Upgrading

| Change | Meaning | What to do |
|--------|---------|------------|
| Patch (`v1.0.1`) | Bug fix, no change to inputs or alerts you didn't expect | Upgrade freely |
| Minor (`v1.1.0`) | New metric or input; existing behavior kept | Read the changes, run `plan` in non-prod first |
| Major (`v2.0.0`) | Breaking: renamed inputs, changed alert names or defaults | Plan the migration; renamed alerts are destroyed and recreated |

After changing a `?ref=`, run `terraform init -upgrade` to fetch the new version, then `plan` and check the diff.

Releasing a new version is covered in [Contributing](contributing.md#releasing-a-module).

## See also

- [Subscription template](subscription-template.md#upgrading-a-copied-template): upgrade a copied template.
- [Contributing](contributing.md#releasing-a-module): release a new version.
