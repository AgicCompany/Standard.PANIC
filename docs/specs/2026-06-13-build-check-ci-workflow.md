---
title: build-check CI workflow for branch-protection compliance
date: 2026-06-13
status: draft
---

# build-check CI Workflow

## Problem

The `AgicCompany` organization ruleset (`ruleset_id 16597941`) protects `main` in
`AgicCompany/Standard.PANIC` and requires a status check named **`build-check`**
(strict mode). No `.github/workflows/` exists in the repo and nothing posts a
`build-check` status, so the required check is permanently `pending`. Result:
**every** pull request to `main` is unmergeable, including the already-open,
already-approved PR #1 (`chore/gitignore-generated-docs`).

## Goal

Add a CI workflow that produces a passing `build-check` status on pull requests to
`main`, satisfying the ruleset so PRs can merge. The check must be meaningful
(catch formatting drift and invalid Terraform) without requiring Azure credentials
or being flaky.

## Constraints & facts

- Required status context is **exactly** `build-check`. In GitHub Actions the
  status context equals the **job name**. A `matrix` would emit
  `build-check (<value>)` contexts that do **not** match — so this must be a
  single job named `build-check`.
- Repository inventory: 5 Terraform roots (`bootstrap`, `prerequisites`,
  `test-resources`, `deployments/appgateway-alerts`,
  `deployments/dev-storage-alerts`), 22 modules under `modules/`, and 1 template
  (`templates/panic-subscription-template`). All declare `terraform >= 1.0`
  (template `>= 1.3.0`) and `azurerm >= 3.0` (template `~> 4.0`).
- `.terraform.lock.hcl` is gitignored — CI resolves providers fresh.
- `terraform validate` does not read backends or remote state; `init -backend=false`
  + `validate` runs without Azure credentials.
- Local Terraform is `v1.15.x`. The repo currently has **formatting drift in 13
  files** (`terraform fmt -check -recursive` fails today). A `fmt` gate therefore
  cannot pass until those files are formatted.
- `main` is PR-protected; direct pushes are rejected. The `gh` token in this
  environment authenticates as `ecstrim`, who is **not** a collaborator and cannot
  create PRs. Git pushes use the `github-agic` SSH remote, which has write access.

## Design

### Workflow file

`.github/workflows/build-check.yml`

- **Trigger:** `pull_request` targeting `main`. **No `paths:` filter** — a
  path-filtered workflow would not report on out-of-scope PRs (e.g. docs-only),
  recreating the exact "required check never reports" failure. Running on every PR
  to `main` is mandatory.
- **Permissions:** `contents: read` (least privilege).
- **Concurrency:** group per ref with `cancel-in-progress: true` to cancel
  superseded runs.
- **Single job named `build-check`**, `runs-on: ubuntu-latest`.

### Job steps

1. `actions/checkout@v4`.
2. `hashicorp/setup-terraform@v3` pinned to `1.15.6` with `terraform_wrapper: false`.
   Pinning to the 1.15.x line keeps CI `fmt` results identical to local output.
3. `actions/cache@v4` over `TF_PLUGIN_CACHE_DIR` so the azurerm provider downloads
   once and is reused across all validated directories.
4. **Format gate:** `terraform fmt -check -recursive` from the repo root (covers
   all `.tf`, including `examples/`).
5. **Validate gate:** discover every directory containing `*.tf`, excluding
   `*/.terraform/*` and `*/examples/*` (→ the 5 roots + 22 modules + 1 template).
   For each: `terraform -chdir=$d init -backend=false -input=false` then
   `terraform -chdir=$d validate`. Collect failures across all dirs (do not abort
   on first failure); exit non-zero if any failed, printing a per-directory summary.

Validate scope intentionally **excludes** `examples/` (formatting is still enforced
on them via the repo-wide `fmt` step).

### Directory discovery

Dynamic discovery (find `*.tf`, strip to unique dirs, filter out `.terraform` and
`examples`) rather than a hardcoded list, so the gate automatically covers new
modules and deployments without workflow edits.

## Landing strategy

Fold all changes into the existing PR #1 branch `chore/gitignore-generated-docs`
as three focused commits:

1. *(already present)* Gitignore `docs/notes/` and `docs/superpowers/`; untrack the
   one tracked plan file.
2. **Format existing Terraform files** — `terraform fmt -recursive` normalizes the
   13 drifted files so the new `fmt` gate passes.
3. **Add build-check CI workflow** — the new `.github/workflows/build-check.yml`.

The spec document itself (this file) lands under `docs/specs/` and is committed as
part of the same branch.

For `pull_request` events GitHub evaluates the workflow from the PR head, so adding
the workflow to PR #1's branch makes `build-check` run on PR #1 itself. Once it
passes, PR #1 (approved, mergeable, currently up to date with `main`) can merge,
landing CI, the formatting fixes, and the gitignore change together.

## Pre-push verification

Before pushing, run locally (mirrors what CI will do):

- `terraform fmt -check -recursive` → must be clean after commit 2.
- For each root/module/template: `terraform init -backend=false` + `terraform
  validate` → must pass, so PR #1 is not blocked by a hidden validate error.

## Risks

- **Pre-existing validate errors** could block PR #1. Mitigation: run validate
  locally before pushing; fix any failures in the same PR.
- **Stale-approval dismissal:** new commits may dismiss `ecstrim`'s approval if the
  ruleset dismisses stale reviews. Re-approval (by `mihaiolaruagic`) may be needed.
- **Workflow-file push:** adding `.github/workflows/*.yml` pushes over the
  `github-agic` SSH remote. SSH pushes are not subject to the HTTPS `workflow`-scope
  restriction, so this should succeed; confirm on push.
- **Strict mode up-to-date:** if `main` advances before PR #1 merges, the branch
  must merge `main` in before it can merge.
- **Provider download time:** ~28 `init` runs. Mitigated by the plugin cache;
  expected runtime ~2-4 min warm.

## Out of scope

- Validating `examples/` directories (formatting only).
- `tflint`, security scanning (`checkov`/`tfsec`), or `terraform plan`.
- Changing the org ruleset or branch-protection configuration.
- Post-merge / `push`-to-`main` workflow triggers.
- Tagging or release automation.

## Success criteria

- `.github/workflows/build-check.yml` exists with a single job named `build-check`.
- On PR #1, the `build-check` status reports **success**.
- `terraform fmt -check -recursive` is clean repo-wide.
- All 5 roots, 22 modules, and the template pass `init -backend=false` + `validate`.
- PR #1 becomes mergeable and merges to `main`.
