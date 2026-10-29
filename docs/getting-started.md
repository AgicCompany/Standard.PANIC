---
title: Getting started
date: 2026-10-28
status: active
version: 1.0
---

# Getting started

In this tutorial you create everything from scratch and end with seven alert rules on one virtual machine. It takes four steps: state storage, action groups, an alert root, and the deployment.

To cover many resources at once, the [subscription template](subscription-template.md) is the better tool, but work through this page first.

## Before you start

You need:

- Terraform 1.3 or later, and the Azure CLI logged in (`az login`) to the subscription you want to use.
- An existing Linux or Windows VM in that subscription. Note its name and resource group.
- These Azure roles:

  | Scope | Role |
  |-------|------|
  | Subscription (to create the resource groups below) | Contributor |
  | Resource group that holds the alerts | Monitoring Contributor |
  | The VM | Monitoring Reader |
  | State storage account | Storage Blob Data Contributor |

## 1. Create remote state storage

`bootstrap/` creates a resource group, a storage account and a container for Terraform state. It keeps its own state locally.

```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars   # set subscription_id; keep the other defaults
terraform init
terraform apply
```

Type `yes` when asked. You should see:

```text
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

Then print the backend settings:

```bash
terraform output -raw backend_config
```

You should see a `terraform { backend "azurerm" { ... } }` block with your storage account name. Keep it open; you use it in the next two steps.

## 2. Create action groups

`prerequisites/` creates the monitoring resource group `rg-monitoring-dev`, a Log Analytics workspace, and two email action groups: `ag-dev-critical` and `ag-dev-warning`.

Its `backend "azurerm"` block only sets the state `key`. The storage settings come from a `backend.hcl` file that you create from `backend.hcl.example`, using the values from step 1.

```bash
cd ../prerequisites
cp terraform.tfvars.example terraform.tfvars   # set subscription_id and your email addresses
cp backend.hcl.example backend.hcl             # set the storage account values from step 1
terraform init -backend-config=backend.hcl
terraform apply
```

You should see:

```text
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

Then print the action group IDs:

```bash
terraform output action_group_ids
```

You should see a map with a `critical` and a `warning` ID, each ending in `/actionGroups/ag-dev-critical` or `/actionGroups/ag-dev-warning`.

## 3. Write the alert root

Create a new folder next to `prerequisites/`, for example `my-first-alerts/`, with one file, `main.tf`. Replace the values in `<...>` with your own: the backend values from step 1, your subscription ID, and your VM.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 6.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "<state resource group from step 1>"
    storage_account_name = "<state storage account from step 1>"
    container_name       = "tfstate"
    key                  = "monitoring/my-first-alerts.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "<subscription id>"
}

data "azurerm_virtual_machine" "app" {
  name                = "<vm name>"
  resource_group_name = "<vm resource group>"
}

data "azurerm_monitor_action_group" "critical" {
  name                = "ag-dev-critical"
  resource_group_name = "rg-monitoring-dev"
}

data "azurerm_monitor_action_group" "warning" {
  name                = "ag-dev-warning"
  resource_group_name = "rg-monitoring-dev"
}

module "vm_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vm?ref=vm/v1.3.1"

  resource_id         = data.azurerm_virtual_machine.app.id
  resource_name       = data.azurerm_virtual_machine.app.name
  resource_group_name = "rg-monitoring-dev"
  profile             = "standard"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }
}

output "alert_names" {
  value = module.vm_alerts.alert_names
}
```

## 4. Deploy the alerts

```bash
cd ../my-first-alerts
terraform init
terraform plan
```

`init` downloads the `vm` module at the tag pinned in `source`. The plan should end with:

```text
Plan: 7 to add, 0 to change, 0 to destroy.
```

The seven alert rules are a warning and a critical alert for CPU, OS disk IOPS and data disk IOPS, plus a critical-only availability alert. Memory and disk free space are off in the `standard` profile.

```bash
terraform apply
```

Type `yes`. You should see `Apply complete! Resources: 7 added` and the `alert_names` output, with names such as `<vm name>-cpu-warn` and `<vm name>-availability-crit`. Unused metrics show as `null`.

Open the Azure portal, go to **Monitor > Alerts > Alert rules**, and filter on resource group `rg-monitoring-dev`. The seven rules are listed there.

## Next steps

- [Concepts](concepts.md): how profiles, overrides and naming work, for example to turn on the memory alert.
- [Thresholds](thresholds.md): what each module alerts on.
- [Subscription template](subscription-template.md): monitor a whole subscription from one `tfvars` file.
- [Versioning](versioning.md): how to pin and upgrade modules.
