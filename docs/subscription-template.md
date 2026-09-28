---
title: Subscription template
date: 2026-09-28
status: draft
version: 0.1
---

# Subscription template

`templates/panic-subscription-template/` monitors a whole subscription from one Terraform root and one `tfvars` file. Use it instead of writing one module block per resource.

The full variable reference, examples and cloning checklist are in the [template README](../templates/panic-subscription-template/README.md). This page explains the design.

## How it works

- **One file per resource type** (`vm.tf`, `sqldb.tf`, ...). Each file calls one PANIC module with `for_each` over an inventory map.
- **Feature switches**: `enable_<type>_alerts = true` turns a resource type on. All switches default to `false`.
- **Inventory maps**: one map per type (`vms`, `sql_databases`, ...). The map key becomes `resource_name`, so it prefixes the alert names.
- **Profiles**: `default_profile` applies to every resource, and an entry can set its own `profile`.
- **Shared inputs**: `resource_group_name`, `action_group_ids` and `tags` are set once and passed to every module.
- **State**: one state file per subscription. Copy `backend.tf.example` to `backend.tf` and fill it in.

```hcl
default_profile  = "standard"
enable_vm_alerts = true

vms = {
  "myorg-app01" = {
    resource_id = "/subscriptions/.../virtualMachines/myorg-app01"
  }
  "myorg-dc01" = {
    resource_id = "/subscriptions/.../virtualMachines/myorg-dc01"
    profile     = "critical"
  }
}
```

## Using it

1. Copy the folder out of this repo, into the repo that will own the subscription's monitoring.
2. Fill in `backend.tf` and `terraform.tfvars`, starting from the `.example` files.
3. `terraform init`, `plan`, `apply`.

The template calls modules by git tag, not by local path. To upgrade a module, change the `?ref=` in that resource type's file. See [Versioning](versioning.md).

The template needs Terraform 1.3 or later and `azurerm ~> 4.0`.
