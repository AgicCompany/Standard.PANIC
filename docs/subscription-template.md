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

## Upgrading a copied template

Your copy has two kinds of files:

- **Upstream files**: every `*.tf` file, `*.example` file and `tests/`. They come from this repo and you shouldn't need to edit them.
- **Your files**: `backend.tf` and `terraform.tfvars`. They hold your settings and inventory and only exist in your copy.

To bring your copy up to date with this repo:

1. Find the commit you copied from. If you didn't record it, compare your `*.tf` files with the template's history to find it. Record the new commit this time, for example in your commit message.
2. See what changed since then:

   ```bash
   git -C <path-to-Standard.PANIC> diff <old-commit> origin/main -- templates/panic-subscription-template/
   ```

3. Check every module whose `?ref=` changed. A new major version (`v1.x` to `v2.0.0`) can change defaults. Read that module's README and its tags in [Versioning](versioning.md#upgrading). For example, `sqlmi/v2.0.0` and `disk/v2.0.0` turned some alerts off by default, so overrides that only set thresholds now also need `enabled = true`.
4. Copy the upstream files over your copy. Don't overwrite `backend.tf` or `terraform.tfvars`.
5. Compare `terraform.tfvars.example` with your `terraform.tfvars`, and add any new or renamed variables and override fields.
6. Download the new module versions and check the result:

   ```bash
   terraform init -upgrade
   terraform validate
   terraform plan
   ```

   `-upgrade` can also update providers within the `versions.tf` constraints and change `.terraform.lock.hcl`. Commit the lock file if it changed.

7. Read the plan before applying. Updates in place are normal. A destroy or a replace means an alert was removed or renamed, so check it against the module's changes before you `terraform apply`.

The template needs Terraform 1.3 or later and `azurerm ~> 4.0`.
