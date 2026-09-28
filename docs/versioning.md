---
title: Versioning
date: 2026-09-28
status: draft
version: 0.1
---

# Versioning

Each module has its own version. Tags use the form `<module>/v<semver>`, for example `vm/v1.0.0` or `storage/v1.2.0`. Upgrading `vm` never forces a change to `storage`.

## Pinning a module

```hcl
source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vm?ref=vm/v1.0.1"
#         └─ repository                                        └─ folder  └─ tag
```

The `//` separates the repository from the folder inside it. Terraform clones the repository at the tag and uses that folder as the module.

Always pin to a full tag. Never use:

- `?ref=main`, which changes under you.
- No `?ref` at all, which means the default branch.

## Current versions

Every module is at `v1.0.0`, except `vm`, `storage`, `appservice` and `postgresql`, which are at `v1.0.1`. `v1.0.1` fixes partial overrides that silently disabled a metric; see [Concepts](concepts.md#overrides). To list tags:

```bash
git ls-remote --tags https://github.com/AgicCompany/Standard.PANIC.git
```

## Upgrading

| Change | Meaning | What to do |
|--------|---------|------------|
| Patch (`v1.0.1`) | Bug fix, no change to inputs or alerts you didn't expect | Upgrade freely |
| Minor (`v1.1.0`) | New metric or input; existing behavior kept | Read the changes, run `plan` in non-prod first |
| Major (`v2.0.0`) | Breaking: renamed inputs, changed alert names or defaults | Plan the migration; renamed alerts are destroyed and recreated |

After changing a `?ref=`, run `terraform init -upgrade` to fetch the new version, then `plan` and check the diff.

Releasing a new version is covered in [Contributing](contributing.md#releasing-a-module).
