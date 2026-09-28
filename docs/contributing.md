---
title: Contributing
date: 2026-09-28
status: draft
version: 0.1
---

# Contributing

This page is for maintainers: people who change modules, add metrics, or release versions.

## Checks before a PR

CI runs one required check, `build-check`, on every PR to `main`. Run the same steps locally:

```bash
terraform fmt -check -recursive      # fix with: terraform fmt -recursive

# validate one module or root, the way CI does
terraform -chdir=modules/vm init -backend=false -input=false
terraform -chdir=modules/vm validate
```

CI validates every folder that contains `.tf` files, except `examples/` folders and `templates/`. CI uses Terraform 1.15.2. If you change a module's inputs, validate its `examples/` folders by hand.

Some modules have tests in `tests/*.tftest.hcl`. They plan against a mock provider, so they need no Azure login:

```bash
terraform -chdir=modules/vm init -backend=false
terraform -chdir=modules/vm test
```

CI doesn't run them yet, so run them when you touch a module that has them. When you change how a module resolves overrides, add or extend its test.

PR titles must follow [Conventional Commits](https://www.conventionalcommits.org/), for example `feat(vm): add network alerts` or `docs: fix override example`. The `conventional-pr-title` workflow enforces this. It's synced from the org's `org-github-management` repo, so don't edit it here.

## Module anatomy

Every resource module has the same files:

| File | Contents |
|------|----------|
| `profiles.tf` | `local.profiles.standard` and `local.profiles.critical`: per metric, `enabled`, `warning_threshold`, `critical_threshold`, `window_minutes` |
| `defaults.tf` | `local.metrics` (Azure metric name, aggregation, operator per metric), `local.resolved` (profile + overrides merged), `local.common_tags` |
| `variables.tf` | Common inputs; `overrides` is a typed object with one optional block per metric |
| `main.tf` | Two `azurerm_monitor_metric_alert` resources per metric, `<metric>_warn` and `<metric>_crit`, each with `count` on `var.enabled && local.resolved.<metric>.enabled` |
| `outputs.tf` | `alert_ids`, `alert_names`, `profile`, `resolved_thresholds` |
| `versions.tf` | `required_providers` |
| `examples/` | `standard/` and `critical-with-overrides/` |

There are two styles in the codebase:

| | Original modules (`vm`, `storage`, `appservice`, `postgresql`) | The other 18 |
|---|---|---|
| Namespace | per metric, in `local.metrics` | one `local.metric_namespace` |
| Severity and frequency | `local.defaults` | written in `main.tf` |

Use the second style for new work.

All modules merge overrides the same way: `coalesce(try(var.overrides.<metric>.<field>, null), <profile value>)`. Don't use a plain `try(var.overrides.<metric>.<field>, <profile value>)`. When an override sets only some fields, `try` returns `null` for the rest instead of the profile value, and a `null` `enabled` silently removes the metric's alerts. Versions `v1.0.0` of the original 4 modules had this bug.

## Adding a metric to a module

1. `profiles.tf`: add the metric to **both** profiles.
2. `defaults.tf`: add it to `local.metrics` and `local.resolved`.
3. `variables.tf`: add an `optional(object({...}))` block to `overrides`.
4. `main.tf`: add the `_warn` and `_crit` resources. Copy an existing pair and change every reference. Omit `_warn` if the metric only has a critical level.
5. Update the module README and, if useful, `examples/critical-with-overrides/`.
6. Regenerate [`thresholds.md`](#regenerating-thresholdsmd).
7. Release a minor version.

## Adding a module

1. Copy the module closest to the new resource type into `modules/<name>/`. Keep the file layout above.
2. Add the module to `TITLES` in `scripts/gen-thresholds.py`, regenerate `thresholds.md`, and add a row to `docs/modules.md`.
3. Add `<name>.tf` to `templates/panic-subscription-template/`, with the feature switch and inventory variable in `variables.tf`, the output in `outputs.tf`, and entries in the template README and `terraform.tfvars.example`.
4. Release `<name>/v1.0.0` **before** merging the template change. The template references the tag, and `terraform init` fails if it doesn't exist.

## Regenerating thresholds.md

Everything below the `GENERATED` marker in `docs/thresholds.md` is written by a script that reads the module code:

```bash
pip install python-hcl2
python3 scripts/gen-thresholds.py
```

Run it after any change to thresholds, windows, enabled flags, metric names or alert names. Commit the result with the code change.

## Releasing a module

1. Merge the change to `main`.
2. Tag the merge commit and push the tag. Tags are the public contract, so agree on the version number before you push.

   ```bash
   git tag vm/v1.1.0
   git push origin vm/v1.1.0
   ```

3. If the module sets a `module-version` tag in `local.common_tags` (only `vm`, `storage`, `appservice` and `postgresql` do), bump it in the same change, before tagging.
4. Bump the `?ref=` in `templates/panic-subscription-template/<name>.tf`.

Use semver as described in [Versioning](versioning.md#upgrading). Changing an alert's name suffix is a major change, because Azure deletes and recreates the rule.

## Known inconsistencies

Worth fixing when you touch these modules:

- `vm` `memory` alerts on "Available Memory Bytes" with percent thresholds (15/10). Enabling it as-is gives wrong alerts. `disk_free` needs checking too: guest metrics may not be published under `Microsoft.Compute/virtualMachines`.
- Tags differ: all modules set `managed-by = terraform`; 4 add `module-version`; `appgateway`, `disk`, `expressroute`, `firewall`, `lb`, `vpngw` add `profile` and `severity`.
- Most modules declare `terraform >= 1.0`, but `optional()` in `overrides` needs 1.3.
- The `vm` examples use a data source (`azurerm_linux_virtual_machine`) that the azurerm provider doesn't have, so they fail `validate`.

## Docs

- User guides live in `docs/`. Keep one topic per page and link instead of repeating.
- Design records live in `docs/specs/YYYY-MM-DD-<slug>.md` with `title`, `date`, `status`, `version` frontmatter. Superseded specs stay for history; mark them `status: superseded`.
- `docs/notes/` and `docs/superpowers/` are gitignored scratch space.
