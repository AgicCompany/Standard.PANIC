---
title: Getting started
date: 2026-09-28
status: draft
version: 0.1
---

# Getting started

This guide takes you from an empty subscription to your first working alerts.

If you already have remote state storage and action groups, skip to [step 3](#3-deploy-alerts).

## What you need

- Terraform 1.3 or later.
- The `azurerm` provider. Modules accept `>= 3.0`; the subscription template needs `~> 4.0`.
- Azure permissions:

  | Scope | Role |
  |-------|------|
  | Resource group that holds the alerts | Monitoring Contributor |
  | Resources you monitor | Monitoring Reader |
  | Action groups | Reader |
  | State storage account | Storage Blob Data Contributor |

- For VM guest metrics (memory, disk free space): Azure Monitor Agent and a data collection rule on each VM. These alerts are off by default.

## 1. Create remote state storage

`bootstrap/` creates a resource group, a storage account and a container for Terraform state. It keeps its own state locally.

```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars   # set subscription_id, names, location
terraform init
terraform apply
terraform output backend_config                # backend block to reuse below
```

## 2. Create action groups

`prerequisites/` creates the monitoring resource group, a Log Analytics workspace, and two email action groups: one for critical alerts, one for warnings.

The `backend "azurerm"` block in `prerequisites/main.tf` points at the maintainers' dev storage account. Replace it with the values from step 1 before you run `init`.

```bash
cd prerequisites
cp terraform.tfvars.example terraform.tfvars   # set names and email receivers
terraform init
terraform apply
terraform output action_group_ids
```

You can skip this step if your organization already has action groups. The modules only need their resource IDs.

## 3. Deploy alerts

Create a Terraform root for your alerts and call one module per monitored resource:

```hcl
module "storage_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/storage?ref=storage/v1.0.1"

  resource_id         = azurerm_storage_account.data.id
  resource_name       = "stproddata01"
  resource_group_name = "rg-monitoring-prod"
  profile             = "standard"

  action_group_ids = {
    critical = "/subscriptions/.../actionGroups/ag-prod-critical"
    warning  = "/subscriptions/.../actionGroups/ag-prod-warning"
  }
}
```

```bash
terraform init
terraform plan
terraform apply
```

Check the result in the Azure portal under **Monitor > Alerts > Alert rules**, filtered by your monitoring resource group.

For working roots that read action groups from remote state, see `deployments/dev-storage-alerts/` and `deployments/appgateway-alerts/`. They use local module paths and hardcoded dev backends, so copy the pattern, not the files.

## Many resources at once

To cover a whole subscription from one `tfvars` file, use the [subscription template](subscription-template.md) instead of writing module blocks by hand.

## Next steps

- [Concepts](concepts.md): how profiles, overrides and naming work.
- [Thresholds](thresholds.md): what each module alerts on.
- [Versioning](versioning.md): how to pin and upgrade modules.
