---
title: build-check CI workflow implementation plan
date: 2026-06-13
status: draft
---

# build-check CI Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a GitHub Actions workflow that emits the org-ruleset-required `build-check` status on PRs to `main`, and land it on the existing PR #1 branch so PR #1 unblocks and merges.

**Architecture:** A single workflow `.github/workflows/build-check.yml` with one job named exactly `build-check`. It runs `terraform fmt -check -recursive` repo-wide, then `terraform init -backend=false` + `terraform validate` over every directory containing `.tf` files except `.terraform/`, `examples/`, and `templates/` (→ 5 roots + 22 modules = 27 dirs). Pre-existing formatting drift in 13 files is fixed first so the fmt gate passes. All work goes onto branch `chore/gitignore-generated-docs` (PR #1), which self-bootstraps the check.

**Tech Stack:** GitHub Actions, Terraform 1.15.2 (`hashicorp/setup-terraform@v3`), azurerm provider, bash.

**Spec:** `docs/specs/2026-06-13-build-check-ci-workflow.md`

**Preconditions:**
- Current branch is `chore/gitignore-generated-docs` (verify: `git branch --show-current`).
- Local Terraform is 1.15.x (verify: `terraform version`).
- Commit messages use plain imperative style (no `feat:`/`chore:` prefixes), matching this repo's history.

---

### Task 1: Format existing Terraform files

Fixes the 13 files with `fmt` drift so the new format gate can pass. One repo-wide `terraform fmt -recursive` normalizes all of them (including the 6 under `examples/`).

**Files (modified by `terraform fmt`):**
- `modules/appservice/main.tf`
- `modules/appservice/profiles.tf`
- `modules/postgresql/profiles.tf`
- `modules/storage/outputs.tf`
- `modules/vm/outputs.tf`
- `modules/vm/profiles.tf`
- `prerequisites/main.tf`
- `modules/keyvault/examples/critical-with-overrides/main.tf`
- `modules/lb/examples/critical-with-overrides/main.tf`
- `modules/mysql/examples/critical-with-overrides/main.tf`
- `modules/redis/examples/critical-with-overrides/main.tf`
- `modules/servicebus/examples/critical-with-overrides/main.tf`
- `modules/storage/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Confirm the gate currently fails (red)**

Run: `terraform fmt -check -recursive`
Expected: exit code non-zero; prints the 13 file paths above.

- [ ] **Step 2: Apply formatting**

Run: `terraform fmt -recursive`
Expected: prints the same file paths as it rewrites them.

- [ ] **Step 3: Confirm the gate now passes (green)**

Run: `terraform fmt -check -recursive`
Expected: exit code 0, no output.

- [ ] **Step 4: Sanity-check the diff is formatting-only**

Run: `git diff --stat`
Expected: only the files listed above, whitespace/alignment changes only (no logic changes). Spot-check with `git diff modules/vm/profiles.tf`.

- [ ] **Step 5: Commit**

```bash
git add -u
git commit -m "Format existing Terraform files"
```

---

### Task 2: Add the build-check workflow

Create the workflow that produces the `build-check` status. The job id and `name` are both `build-check` so the reported status context is exactly `build-check` (matrix or reusable-workflow calls would not match).

**Files:**
- Create: `.github/workflows/build-check.yml`

- [ ] **Step 1: Create the workflow file**

Create `.github/workflows/build-check.yml` with exactly this content:

```yaml
name: build-check

on:
  pull_request:
    branches: [main]

permissions:
  contents: read

concurrency:
  group: build-check-${{ github.ref }}
  cancel-in-progress: true

jobs:
  build-check:
    name: build-check
    runs-on: ubuntu-latest
    env:
      TF_IN_AUTOMATION: "1"
      TF_INPUT: "0"
      TF_PLUGIN_CACHE_DIR: ${{ github.workspace }}/.tf-plugin-cache
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.15.2
          terraform_wrapper: false

      - name: Cache provider plugins
        uses: actions/cache@v4
        with:
          path: ${{ env.TF_PLUGIN_CACHE_DIR }}
          key: tf-plugins-${{ runner.os }}-${{ hashFiles('**/versions.tf', '**/main.tf') }}
          restore-keys: |
            tf-plugins-${{ runner.os }}-

      - name: Terraform format check
        run: terraform fmt -check -recursive

      - name: Terraform validate (roots + modules)
        run: |
          set -euo pipefail
          mkdir -p "$TF_PLUGIN_CACHE_DIR"
          mapfile -t dirs < <(find . -type f -name '*.tf' \
            -not -path '*/.terraform/*' \
            -not -path '*/examples/*' \
            -not -path '*/templates/*' \
            -exec dirname {} \; | sort -u)
          echo "Discovered ${#dirs[@]} directories to validate."
          failed=()
          for d in "${dirs[@]}"; do
            echo "::group::validate ${d}"
            if terraform -chdir="${d}" init -backend=false -input=false -no-color \
               && terraform -chdir="${d}" validate -no-color; then
              echo "PASS: ${d}"
            else
              echo "FAIL: ${d}"
              failed+=("${d}")
            fi
            echo "::endgroup::"
          done
          echo "----------------------------------------"
          if [ "${#failed[@]}" -gt 0 ]; then
            echo "Validation FAILED for ${#failed[@]} dir(s): ${failed[*]}"
            exit 1
          fi
          echo "All ${#dirs[@]} directories passed validate."
```

- [ ] **Step 2: Confirm formatting is still clean**

Run: `terraform fmt -check -recursive`
Expected: exit 0 (the `.yml` is not Terraform, but this confirms Task 1 still holds).

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/build-check.yml
git commit -m "Add build-check CI workflow"
```

---

### Task 3: Locally verify the workflow's checks before pushing

Mirror exactly what CI will do, so PR #1 is not blocked by a surprise. This downloads the azurerm provider and may take a few minutes.

- [ ] **Step 1: Confirm discovery returns the 27 expected dirs**

Run:
```bash
find . -type f -name '*.tf' \
  -not -path '*/.terraform/*' \
  -not -path '*/examples/*' \
  -not -path '*/templates/*' \
  -exec dirname {} \; | sort -u | tee /tmp/build-check-dirs.txt
wc -l < /tmp/build-check-dirs.txt
```
Expected: 27 lines. The list includes `./bootstrap`, `./prerequisites`, `./test-resources`, `./deployments/appgateway-alerts`, `./deployments/dev-storage-alerts`, and `./modules/<name>` for all 22 modules. It MUST NOT include any path under `templates/`, `examples/`, or `.terraform/`.

- [ ] **Step 2: Run the validate loop locally**

Run:
```bash
export TF_PLUGIN_CACHE_DIR="$PWD/.tf-plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"
failed=()
while IFS= read -r d; do
  echo "=== validate ${d} ==="
  if terraform -chdir="${d}" init -backend=false -input=false -no-color \
     && terraform -chdir="${d}" validate -no-color; then
    echo "PASS: ${d}"
  else
    echo "FAIL: ${d}"
    failed+=("${d}")
  fi
done < /tmp/build-check-dirs.txt
echo "Failures: ${#failed[@]} ${failed[*]:-}"
```
Expected: `Failures: 0`. Every directory prints `Success! The configuration is valid.` and `PASS`.

- [ ] **Step 3: Clean up local Terraform artifacts (do not commit them)**

Run:
```bash
find . -type d -name '.terraform' -prune -exec rm -rf {} +
rm -rf "$PWD/.tf-plugin-cache"
git status --porcelain
```
Expected: `git status --porcelain` shows no new untracked `.terraform/` dirs or lock files. (`.terraform/` and `.terraform.lock.hcl` are already gitignored, but confirm nothing slipped through.)

---

### Task 4: Push and verify build-check on PR #1

- [ ] **Step 1: Push the branch**

Run: `git push origin chore/gitignore-generated-docs`
Expected: push succeeds over the `github-agic` SSH remote. If it is rejected for a workflow-scope reason, STOP and report — pushing `.github/workflows/*` may be restricted and needs the user to push or adjust credentials.

- [ ] **Step 2: Watch the check run**

Run: `gh pr checks 1 --repo AgicCompany/Standard.PANIC --watch`
Expected: a check named exactly `build-check` appears and ends `pass`. (If `gh` lacks read access, use the PR's Checks tab in the browser.)

- [ ] **Step 3: Confirm PR #1 is no longer blocked by the check**

Run:
```bash
gh pr view 1 --repo AgicCompany/Standard.PANIC \
  --json mergeStateStatus,reviewDecision,mergeable
```
Expected: `mergeable: MERGEABLE`. `mergeStateStatus` should move off `BLOCKED` toward `CLEAN` (or `BEHIND` if `main` advanced — then merge `main` into the branch and re-push). If `reviewDecision` reverted from `APPROVED` (stale-review dismissal), re-approval by `mihaiolaruagic` is needed.

- [ ] **Step 4: Manual follow-ups (flag to user — `gh` as `ecstrim` cannot do these)**

- Update PR #1 title/description to reflect the broadened scope (gitignore + Terraform formatting + build-check CI + planning docs). The author/a collaborator must edit it via the GitHub UI.
- Merge PR #1 once `build-check` is green and the review requirement is satisfied.

---

## Notes / out of scope (from spec)

- The `templates/panic-subscription-template` directory is intentionally excluded from validate: it pins released module tags over the network and currently fails `init` (references a non-existent `vmss/v1.0.0` module — a separate pre-existing bug). `fmt` still covers it.
- No `tflint`/security scanning/`terraform plan`, no `push`-to-`main` trigger, no ruleset changes.
