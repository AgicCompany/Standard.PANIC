# Getting Started

This guide walks you through deploying PANIC alerts for your Azure resources.

## Prerequisites

Before deploying alert modules, ensure you have:

| Component | Purpose | Notes |
|-----------|---------|-------|
| Log Analytics Workspace | Destination for metrics | Required for guest metrics |
| Azure Monitor Agent | Guest metrics collection | Required for VM memory/disk |
| Data Collection Rules | Metric routing | Must target Log Analytics |
| Action Groups | Alert notifications | Created separately |

## Quick Start

### 1. Deploy Bootstrap (State Backend)

Set up remote state storage for Terraform:

```bash
cd bootstrap
terraform init
terraform apply
```

### 2. Deploy Prerequisites

Create Log Analytics Workspace and Action Groups:

```bash
cd prerequisites
terraform init
terraform apply -var-file=terraform.tfvars
```

### 3. Deploy Alerts

Deploy monitoring for your resources:

```bash
cd deployments/dev-storage-alerts
terraform init
terraform apply
```

## Basic Usage

```hcl
module "storage_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-storage.git?ref=v1.0.0"

  resource_id    = azurerm_storage_account.example.id
  resource_name  = "mystorageaccount"
  profile        = "standard"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

## Using Overrides

Customize specific metrics while keeping profile defaults:

```hcl
module "vm_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vm.git?ref=v1.0.0"

  resource_id    = azurerm_virtual_machine.batch.id
  resource_name  = "batch-processor"
  profile        = "standard"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    cpu = {
      warning_threshold  = 95  # Higher threshold for batch workloads
      critical_threshold = 99
    }
    memory = {
      enabled = false  # Disable memory alerts
    }
  }
}
```

## State Management

Use remote state for team collaboration:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate"
    container_name       = "tfstate"
    key                  = "monitoring/prod.tfstate"
  }
}
```

## Next Steps

- Review [available modules](modules.md) for your resource types
- Understand the [profile system](profiles.md)
- See the [architecture guide](architecture.md) for advanced usage
