---
title: Documentation index
date: 2026-10-28
status: active
version: 1.0
---

# Documentation

Every page in `docs/`, grouped by what you need. Module-specific details are in each `modules/<name>/README.md`.

## Learn

- [Getting started](getting-started.md): deploy your first alerts on one VM.

## Do a task

- [Subscription template](subscription-template.md): monitor a whole subscription, and upgrade a copied template.
- [Versioning](versioning.md): pin and upgrade module versions.
- [Contributing](contributing.md): run the checks, change or add a module, release a version.

## Look something up

- [Modules](modules.md): which module covers which Azure resource type, and the common inputs and outputs.
- [Thresholds](thresholds.md): every metric with its default thresholds, generated from the code.
- [Subscription template README](../templates/panic-subscription-template/README.md): every template variable, inventory map and output.

## Understand the design

- [Concepts](concepts.md): deployment model, profiles, overrides and alert naming.

## Design records

Specs and plans behind past changes. They describe the state at the time they were written; the pages above describe the current state.

| Record | Status |
|--------|--------|
| [Implementation guide](specs/2026-01-29-implementation-guide.md) | superseded |
| [Subscription template spec](specs/2026-02-03-subscription-template-spec.md) | superseded |
| [build-check CI workflow](specs/2026-06-13-build-check-ci-workflow.md) ([plan](specs/2026-06-13-build-check-ci-workflow-plan.md)) | implemented |
| [Template typed overrides plan](specs/2026-09-28-template-typed-overrides-plan.md) | implemented |
| [vmss module](specs/2026-09-28-vmss-module.md) ([plan](specs/2026-09-28-vmss-module-plan.md)) | implemented |
