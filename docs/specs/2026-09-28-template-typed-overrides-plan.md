---
title: Template typed overrides - implementation plan
date: 2026-09-28
status: active
version: 1.0
---

# Template Typed Overrides Implementation Plan

**Goal:** The subscription template accepts different override shapes on
different resources of one type, and resources with and without overrides in
the same map.

**Bug:** `templates/panic-subscription-template/variables.tf` declares
`overrides = optional(map(any))` in all 22 inventory variables. A map needs one
common element type, so `vm-a = { overrides = { cpu = {...} } }` next to
`vm-b = { overrides = { memory = {...} } }` fails at plan with
`attribute types must all match for conversion to map`. The template README's
own example hits it. See "Known limitation" in
`docs/specs/2026-09-28-vmss-module.md`.

**Decision:** Replace `optional(map(any))` with `optional(<typed object>)`,
where the typed object is copied verbatim from the `type = object({...})` of
`variable "overrides"` in the matching `modules/<module>/variables.tf`.
`optional(any)` was tried and rejected: it fails with the same error, because
`any` inside a map must still resolve to one type. The module types at the
tags the template pins are identical to `modules/` on this branch (checked
2026-09-28), so copy from `modules/`.

**Scope:** Only `templates/panic-subscription-template/variables.tf` and a new
`templates/panic-subscription-template/tests/overrides.tftest.hcl`. No module
changes, no `?ref=` bumps, no tags, no README changes.

**Tech stack:** Terraform 1.15.2, `hashicorp/azurerm ~> 4.0`, `terraform test`
with `mock_provider`.

## Global constraints

- Offline only. There are no Azure credentials. Never run `terraform plan`,
  `apply` or `import` outside `terraform test`. Verify only with
  `terraform fmt`, `terraform init -backend=false`, `terraform validate` and
  `terraform test`.
- Run every Terraform command from `templates/panic-subscription-template/`
  unless the step says otherwise.
- `terraform init` downloads the modules from GitHub by tag and the azurerm
  provider. It needs network access. It does not need credentials.
- Never commit `.terraform/` or `.terraform.lock.hcl` (both are gitignored).
- Commit messages use Conventional Commits.

## Variable to module map

| Variable in `variables.tf` | Module |
|---|---|
| `vms` | `vm` |
| `storage_accounts` | `storage` |
| `postgresql_servers` | `postgresql` |
| `app_services` | `appservice` |
| `app_gateways` | `appgateway` |
| `vmss` | `vmss` |
| `managed_disks` | `disk` |
| `load_balancers` | `lb` |
| `vpn_gateways` | `vpngw` |
| `expressroute_circuits` | `expressroute` |
| `firewalls` | `firewall` |
| `sql_databases` | `sqldb` |
| `sql_managed_instances` | `sqlmi` |
| `mysql_servers` | `mysql` |
| `cosmosdb_accounts` | `cosmosdb` |
| `aks_clusters` | `aks` |
| `function_apps` | `function` |
| `container_apps` | `containerapp` |
| `key_vaults` | `keyvault` |
| `service_bus_namespaces` | `servicebus` |
| `event_hubs` | `eventhub` |
| `redis_caches` | `redis` |

## Task 1: Failing test for mixed VM override shapes

**Files:** create `templates/panic-subscription-template/tests/overrides.tftest.hcl`

- [ ] Step 1: Create the file with exactly this content:

```hcl
# Overrides for different metrics on different resources of one type must be
# accepted, and a resource without overrides may sit next to one with them.

mock_provider "azurerm" {}

variables {
  subscription_id     = "00000000-0000-0000-0000-000000000000"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "mixed_override_shapes" {
  command = plan

  variables {
    enable_vm_alerts = true
    vms = {
      vm-cpu = {
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/virtualMachines/vm-cpu"
        overrides   = { cpu = { warning_threshold = 90 } }
      }
      vm-mem = {
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/virtualMachines/vm-mem"
        overrides   = { memory = { enabled = false } }
      }
      vm-plain = {
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/virtualMachines/vm-plain"
      }
    }
  }

  assert {
    condition     = length(module.vm_alerts) == 3
    error_message = "all three VMs must get an alert module instance"
  }

  assert {
    condition     = module.vm_alerts["vm-cpu"].resolved_thresholds.cpu.warning_threshold == 90
    error_message = "vm-cpu must keep its cpu warning override"
  }
}
```

- [ ] Step 2: Run:

```bash
terraform init -backend=false -input=false -no-color
terraform test -no-color
```

Expected: init succeeds. The test fails, and the output contains
`The given value is not suitable for var.vms`,
`attribute types must all match for conversion to map` and
`Failure! 0 passed, 1 failed.`

- [ ] Step 3: Commit: `test(template): mixed override shapes per resource type`

## Task 2: Typed overrides for `vms`

**Files:** modify `templates/panic-subscription-template/variables.tf`

- [ ] Step 1: In `variable "vms"`, replace the line
  `    overrides   = optional(map(any))` with `overrides = optional(` followed
  by the `object({ ... })` from `variable "overrides"` in
  `modules/vm/variables.tf` (the whole value of its `type =`, from `object({`
  to the matching `})`), then `)`. Do not copy the module's `description`,
  `default` or `validation`. The result starts like this:

```hcl
variable "vms" {
  description = "Virtual Machines to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides = optional(object({
      cpu = optional(object({
        enabled            = optional(bool)
        warning_threshold  = optional(number)
        critical_threshold = optional(number)
        window_minutes     = optional(number)
      }))
      # ... every other metric from modules/vm/variables.tf, same shape
    }))
  }))
  default = {}
}
```

- [ ] Step 2: Run `terraform fmt -recursive`, then `terraform fmt -check -recursive`.
  Expected: the check prints nothing and exits 0.
- [ ] Step 3: Run `terraform validate -no-color`. Expected: `Success! The configuration is valid.`
- [ ] Step 4: Run `terraform test -no-color`. Expected: `Success! 1 passed, 0 failed.`
- [ ] Step 5: Commit: `fix(template): typed overrides for vms`

## Task 3: Typed overrides for the other 21 variables

**Files:** modify `templates/panic-subscription-template/tests/overrides.tftest.hcl`
and `templates/panic-subscription-template/variables.tf`

- [ ] Step 1: Append this run block to the end of `tests/overrides.tftest.hcl`:

```hcl
run "mixed_override_shapes_storage" {
  command = plan

  variables {
    enable_storage_alerts = true
    storage_accounts = {
      st-latency = {
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/stlatency"
        overrides   = { latency = { warning_threshold = 500 } }
      }
      st-avail = {
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/stavail"
        overrides   = { availability = { enabled = false } }
      }
      st-plain = {
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/stplain"
      }
    }
  }

  assert {
    condition     = length(module.storage_account_alerts) == 3
    error_message = "all three storage accounts must get an alert module instance"
  }

  assert {
    condition     = module.storage_account_alerts["st-latency"].resolved_thresholds.latency.warning_threshold == 500
    error_message = "st-latency must keep its latency warning override"
  }
}
```

- [ ] Step 2: Run `terraform test -no-color`. Expected: the output contains
  `The given value is not suitable for var.storage_accounts` and
  `Failure! 1 passed, 1 failed.`
- [ ] Step 3: For every row of the variable to module map except `vms`, apply
  the same replacement as Task 2 Step 1, copying from
  `modules/<module>/variables.tf`. Each variable gets its own module's type.
- [ ] Step 4: Check no untyped overrides remain:
  `grep -c 'optional(map(any))' variables.tf`. Expected: `0`.
  Also `grep -c 'overrides = optional(object({' variables.tf`. Expected: `22`.
- [ ] Step 5: Run `terraform fmt -recursive`, then `terraform fmt -check -recursive`.
  Expected: prints nothing, exit 0.
- [ ] Step 6: Run `terraform validate -no-color`. Expected: `Success! The configuration is valid.`
- [ ] Step 7: Run `terraform test -no-color`. Expected: `Success! 2 passed, 0 failed.`
- [ ] Step 8: Commit: `fix(template): typed overrides for all resource types`

## Final check

From the repository root: `terraform fmt -check -recursive` prints nothing and
exits 0. `git status --short` shows no untracked `.terraform` files.
