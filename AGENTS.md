# AGENTS.md

PANIC is a Terraform framework for Azure Monitor metric alerts (`azurerm_monitor_metric_alert`) using predefined profiles (`standard`, `critical`) and typed `overrides`.

## Essential repository rules

- **Architecture & modules**: 22 resource modules + generic `base` live in `modules/<name>/`; `templates/panic-subscription-template/` wraps all 22 behind feature switches.
- **Override resolution**: Always merge overrides with `coalesce(try(var.overrides.<metric>.<field>, null), <profile_value>)` — never plain `try(...)`, which turns omitted fields into `null`.
- **Independent versioning**: Modules are released via Git tags `<module>/v<semver>` (e.g. `vm/v1.0.1`). Release the module tag before bumping `?ref=` in `templates/panic-subscription-template/<name>.tf`.
- **Verification**: Run `terraform fmt -check -recursive`, `terraform -chdir=<dir> init -backend=false && terraform -chdir=<dir> validate`, and `terraform -chdir=<dir> test` where `tests/*.tftest.hcl` exist.
- **Org-managed files**: Never edit `.github/dependabot.yml`, `.github/workflows/case-rename-policy.yml`, or `.github/workflows/conventional-pr-title.yml` (synced from `org-github-management`).

## Progressive discovery & living docs

- **Maintainer workflows** (adding metrics/modules, releasing, style): read [`docs/contributing.md`](docs/contributing.md).
- **Domain & thresholds**: read [`docs/concepts.md`](docs/concepts.md), [`docs/modules.md`](docs/modules.md), and [`docs/thresholds.md`](docs/thresholds.md).
- **Writing & updating documentation**: invoke and follow [`.agents/skills/write-documentation/SKILL.md`](.agents/skills/write-documentation/SKILL.md).
- **Keep documentation in sync**: Any change to metrics, thresholds, variables, outputs, versions, or workflows MUST update the corresponding `README.md` / `docs/*.md` and regenerate `docs/thresholds.md` (`python3 scripts/gen-thresholds.py`) in the same PR.
- **Keep `AGENTS.md` updated**: When structural changes or durable architectural decisions are made, update `AGENTS.md` in the same change while keeping it under 100 lines.

## Git workflow

Commit often with conventional commit messages. Use branches for features and fixes; merge only code that is reviewed and tested.

## Behavioral guidelines

**Write everything in English** — code, comments, docs, commit messages — regardless of the conversation language.

### No unverified technical claims

Explain how a technology, SDK, or tool works only when you have read the source, official documentation, or verified output that proves it. If you cannot cite the file, URL, or command output behind a claim, say "I don't know". Label assumptions explicitly as assumptions.

### Think before coding

State your assumptions; if uncertain, ask. If multiple interpretations exist, present them instead of picking silently. If a simpler approach exists, say so — push back when warranted. If something is unclear, stop and name what's confusing.

### Simplicity first

Write the minimum code that solves the problem: no features beyond what was asked, no abstractions for single-use code, no unrequested configurability, no error handling for impossible scenarios. If 200 lines could be 50, rewrite. Test: would a senior engineer call it overcomplicated?

### Surgical changes

Every changed line must trace directly to the request. Match existing style; leave adjacent code, comments, and formatting untouched. Remove imports/variables/functions that *your* change orphaned; mention pre-existing dead code instead of deleting it.

### Goal-driven execution

Transform tasks into verifiable goals ("fix the bug" → "write a test that reproduces it, then make it pass") and loop until the check passes. For multi-step tasks, state a brief plan with a verification per step.
