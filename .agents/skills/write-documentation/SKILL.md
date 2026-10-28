---
name: write-documentation
description: Write and maintain Standard.PANIC documentation using the Diataxis framework adapted to this repository's flat Markdown layout (`docs/`, `modules/*/README.md`, `templates/panic-subscription-template/README.md`). Use this skill whenever the user asks to write docs, add or update a documentation page, create or update a module or template README, document metrics/thresholds/overrides, decide where documentation belongs, or keep docs in sync with Terraform changes — even if they just say "document this" or "the docs are stale". Also use it whenever an implementation change alters variables, outputs, metric definitions, thresholds, version tags, or workflows.
---

# Diataxis documentation for Standard.PANIC (Markdown)

Documentation earns trust by being findable and correct. This skill enforces both: every page serves a clear Diataxis quadrant so readers know what to expect from it, and every claim is traced to the Terraform source code or Git tags so pages don't rot into fiction.

## The four quadrants in Standard.PANIC

Standard.PANIC keeps a **flat file structure under `docs/`** (plus per-module and template READMEs) rather than nested quadrant subdirectories, because `scripts/gen-thresholds.py` and existing links target `docs/*.md` directly. Every file still belongs to one primary quadrant:

| Quadrant | Files in this repository | Reader's question | Orientation |
| --- | --- | --- | --- |
| **Tutorials** | `docs/getting-started.md` | "Teach me by doing" | Learning |
| **How-to guides** | `docs/subscription-template.md`, `docs/versioning.md`, `docs/contributing.md` | "How do I do X?" | Task |
| **Reference** | `docs/modules.md`, `docs/thresholds.md`, `modules/<name>/README.md`, `templates/panic-subscription-template/README.md` | "What's the exact value/shape?" | Information |
| **Explanation** | `docs/concepts.md`, `docs/specs/YYYY-MM-DD-<slug>.md` (design records / ADRs) | "Why is it like this?" | Understanding |

Decision tree for placing content:

```
Is it about DOING something?
├── YES: is the reader LEARNING or ACCOMPLISHING?
│   ├── LEARNING → Tutorial (`docs/getting-started.md`)
│   └── ACCOMPLISHING → How-to (`docs/subscription-template.md`, `docs/versioning.md`, `docs/contributing.md`)
└── NO: is it FACTS or UNDERSTANDING?
    ├── FACTS → Reference (`docs/modules.md`, `docs/thresholds.md`, `modules/<name>/README.md`, template `README.md`)
    └── UNDERSTANDING → Explanation (`docs/concepts.md`, or `docs/specs/` for historical/design decisions)
```

A page that tries to do two jobs does neither well. Keep each page focused on its quadrant and cross-link to the others instead.

## Per-quadrant rules

**Tutorials (`docs/getting-started.md`)** — step-by-step, one clear path from an empty setup to working alerts, exact commands (`terraform init`, `terraform apply`), show what the reader should SEE at each step. Never offer branching choices mid-path (note that alternatives like the subscription template exist and link out, then stay on the single happy path). Test every command or example against real Terraform syntax (`terraform validate`).

**How-to guides (`docs/subscription-template.md`, `docs/versioning.md`, `docs/contributing.md`)** — start with the goal ("To upgrade a pinned module, ..."), numbered steps, prerequisites up front, end with how to verify it worked (`terraform plan`, `terraform validate`, `terraform test`). No concept teaching — link to `docs/concepts.md` instead.

**Reference (`docs/modules.md`, `docs/thresholds.md`, `modules/<name>/README.md`, `templates/panic-subscription-template/README.md`)** — austere, neutral, complete. Tables for inputs, outputs, metrics, thresholds, and feature switches: name, type, default, required, purpose. Document ALL variables, outputs, and override keys that exist in `.tf` files. Never hand-edit the generated section of `docs/thresholds.md` below `<!-- GENERATED: tables below are written by scripts/gen-thresholds.py -->`; always run `python3 scripts/gen-thresholds.py`.

**Explanation (`docs/concepts.md`, `docs/specs/*.md`)** — discursive: why alerts live in a separate Terraform layer, how profiles (`standard` vs `critical`) and partial `overrides` work (`coalesce(try(...))`), naming conventions, trade-offs. Use fenced `mermaid` blocks for architecture and data-flow diagrams. Historical or superseded design specs stay in `docs/specs/` with `status: superseded` frontmatter and a banner linking to the current pages.

## Ground every claim in the code

The failure mode of docs is plausible-sounding drift. Before writing any factual claim (a threshold, an operator, a window, a variable type, a provider constraint, or a module tag), read the source that owns it:

- **Thresholds, windows, and enabled defaults** → `modules/<name>/profiles.tf` (never copy from `docs/specs/2026-01-29-implementation-guide.md`, which is superseded).
- **Azure metric names, namespaces, aggregations, operators, and tags** → `modules/<name>/defaults.tf` and `modules/<name>/main.tf`.
- **Inputs and override object shapes** → `modules/<name>/variables.tf` and `templates/panic-subscription-template/variables.tf`.
- **Outputs** → `modules/<name>/outputs.tf` and `templates/panic-subscription-template/outputs.tf`.
- **Terraform and provider versions** → `versions.tf` in the target module or template.
- **Module release versions (`?ref=<module>/v<version>`)** → verify with `git tag -l '<module>/v*'` and `templates/panic-subscription-template/<name>.tf`.
- **CI checks and commands** → `.github/workflows/build-check.yml`.

If you cannot verify a claim against the codebase or official Terraform/Azure Monitor docs, drop it or flag it explicitly as unverified.

## Cross-link, don't duplicate

Single source of truth: every rule, threshold table, or input specification lives in one canonical place. Link to it instead of restating it:

- `docs/thresholds.md` owns the full metric and threshold tables; `docs/modules.md` and `docs/concepts.md` link to its anchors.
- `docs/concepts.md` owns common module inputs/outputs and override semantics; `docs/modules.md` links to `concepts.md#common-inputs-and-outputs`.
- `templates/panic-subscription-template/README.md` owns the full template variable and inventory reference; `docs/subscription-template.md` explains the design and links to the template README.
- End pages in `docs/` with a short reference or link to related pages across quadrants.

## Filenames, frontmatter, and structure

- Files in `docs/` use `lowercase-hyphen.md` and YAML frontmatter (`title`, `date`, `status`, `version`).
- Design records live in `docs/specs/YYYY-MM-DD-<slug>.md`.
- Scratch notes belong in gitignored folders (`docs/notes/`) or session artifacts — never commit working notes to `docs/`.
- Root `README.md` is the entry point and navigation table for `docs/*.md`. When adding a guide in `docs/`, add it to the Documentation table in `README.md` and cross-link from related pages.

## Verify before finishing

1. **Regenerate thresholds** — if any module's `profiles.tf`, `defaults.tf`, or `main.tf` changed, run `python3 scripts/gen-thresholds.py` and confirm `docs/thresholds.md` has no uncommitted drift.
2. **Link check** — verify every relative Markdown link and heading anchor across all touched `.md` files.
3. **Code & example parity** — check that HCL snippets in `README.md`, `docs/*.md`, and `modules/*/README.md` use valid data sources, existing module tags, and current variable names/types.
4. **Quadrant discipline** — confirm no page mixes quadrants (e.g. a how-to teaching concepts, or a reference page duplicating tutorial steps).

## Keeping docs in sync

When an implementation change alters module behavior, thresholds, variables, outputs, tags, or CI workflows, update the affected docs in the same commit or PR. New architectural or design decisions belong in `docs/specs/YYYY-MM-DD-<slug>.md` (and `AGENTS.md` if they affect repo-wide agent rules).
