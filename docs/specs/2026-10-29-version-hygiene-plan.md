---
title: Version and tag hygiene plan (issues #23, #22, #20)
date: 2026-10-29
status: implemented
version: 0.3
---

# Version and tag hygiene plan

Covers issues #23, #22 and #20 (all children of #12). Three independent branches, one PR each. Order: #23, #22, #20.

## Findings (verified in the repo)

- `required_version`: 44 files say `>= 1.0`, 2 say `>= 1.3` (vmss). `optional()` needs 1.3.
- `azurerm` in modules: 12 files use `>= 3.0`, 11 use `>= 3.0.0`. Template pins `~> 4.0`.
- Dependabot PR #11 now proposes `~> 5.11` (the issue says 5.10). Not tested against any module.
- `local.common_tags`: `vm`/`storage`/`appservice`/`postgresql` add `module-version`; 6 modules (`appgateway`, `disk`, `expressroute`, `firewall`, `lb`, `vpngw`) inline `managed-by`, `profile`, `severity` per resource; the rest set only `managed-by`.
- Every module change needs a new module tag, then a `?ref=` bump in the template (see `docs/contributing.md`).

## Decisions (approved 2026-10-29)

1. **Provider range (#22).** Approved: `>= 4.0, < 6.0` in all modules only if `terraform test` passes on both 4.x and 5.x; otherwise `>= 4.0, < 5.0` and close PR #11. Dropping 3.x support is a breaking-ish change; confirm nobody uses 3.x.
2. **Tag set (#20).** Approved: `managed-by` only in `common_tags` (drop `module-version`, which needs manual bumps), and add `profile` and `severity` per alert where today's 6 modules have them. Owner does not know of any user of `module-version` and accepts dropping it.
3. **Release type.** Version-constraint changes: patch or minor. Tag changes: minor (tags change on live alerts, in place; names do not change, so no recreate).

## Task 1: required_version >= 1.3 (#23)

- In `modules/*/versions.tf`, set `required_version = ">= 1.3"` (44 files to change; check `examples/*/versions.tf` too, and `modules/base`, which does not use `optional()` but the issue lists 22 modules).
- Update `terraform >= 1.0` in each `modules/*/README.md`, and in `docs/` if mentioned.
- Verify: `grep -rn '">= 1.0"' modules` returns nothing; `terraform fmt -check -recursive`; `init -backend=false && validate` for every touched dir; `terraform test` where tests exist.
- Release: one tag per changed module, then template `?ref=` bumps.

## Task 2: bound azurerm (#22)

- Spike first: run `terraform test` for modules with tests (`vm`, `vmss`, `storage`, `appservice`, `postgresql`, `disk`, `sqlmi`) and `validate` for all modules on azurerm 4.x and 5.x (temporary constraint, not committed).
- Set the agreed constraint in all `modules/*/versions.tf` (one spelling).
- Template: keep `~> 4.0`, or accept PR #11 only if the spike passes; then update `docs/getting-started.md:15`, `docs/subscription-template.md:46`, `templates/panic-subscription-template/README.md:38`.
- Close or merge PR #11 with a comment pointing to the result. Ask before commenting or merging.
- Verify: same fmt/validate/test commands; `grep -rn 'version *= *">= 3' modules` returns nothing.

## Task 3: common_tags (#20)

- Add or normalise `local.common_tags` in `defaults.tf` for all 22 modules, per decision 2.
- For the 6 inline-tag modules, replace the per-resource `merge(var.tags, {...})` with `local.common_tags` (severity differs per warn/crit alert, so those keep `merge(local.common_tags, { severity = ... })`).
- Add one test assertion per touched module checking alert `tags` (use existing `tests/*.tftest.hcl` where present; modules without tests get a small `tags.tftest.hcl`; mocked provider, no Azure calls).
- Update `docs/contributing.md` (the "Known inconsistencies" tag and `module-version` lines, step 3 in the release section) and the vm/storage/appservice/postgresql READMEs if they mention the tag.
- Verify: fmt, validate, test for every touched dir.

## Shared acceptance for each PR

- `terraform fmt -check -recursive`, `init -backend=false && validate`, `terraform test` where present.
- `python3 scripts/gen-thresholds.py` if thresholds docs are affected (not expected).
- Branch per task, conventional commit titles, no push or PR without approval.
- No `apply`/`destroy`.

## Risks

- Tag changes update live alerts in place on next apply (noise in plans, not outages).
- Raising `required_version` blocks users on Terraform 1.0-1.2; call it out in release notes.
- Many modules per PR: split by module batches if review gets heavy.
