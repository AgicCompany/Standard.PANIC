# Subscription Template Specification

## Document Information

| Attribute | Value |
|-----------|-------|
| Version | 1.0 |
| Status | Draft |
| Last Updated | 2025-02 |

---

## 1. Overview

This document specifies the design for `panic-subscription-template`, a Terraform template for deploying PANIC alert rules across an Azure subscription. The template provides a standardised, repeatable method for teams to enable monitoring using feature switches and inventory-based configuration.

### 1.1 Goals

- Provide a single template that covers all 22 PANIC resource types
- Enable resource type selection via feature switches
- Support per-resource profile selection and overrides
- Minimise boilerplate and repetition for deployment teams
- Maintain consistency with PANIC module conventions

### 1.2 Non-Goals

- Action group creation (prerequisite, passed as input)
- Resource provisioning (monitoring layer only)
- Multi-subscription deployments (one template instance per subscription)

---

## 2. Version Constraints

### 2.1 Terraform and Provider Versions

The template requires Terraform 1.3.0 or later for `optional()` attribute support in variable type definitions. The AzureRM provider is pinned to a specific minor version to avoid unexpected changes.

**versions.tf:**

```hcl
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
```

### 2.2 Module Version Pinning

All PANIC module references must use explicit version tags.

**Required format:**

```hcl
source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vm.git?ref=v1.0.0"
```

**Version update strategy:**

| Scenario | Action |
|----------|--------|
| Patch release (v1.0.1) | Update at discretion, low risk |
| Minor release (v1.1.0) | Review changelog, test in non-prod first |
| Major release (v2.0.0) | Breaking changes expected, plan migration |

**Never use:**

- `?ref=main` or `?ref=master` (unstable)
- No ref at all (defaults to HEAD)
- `?ref=v1` (floats to latest v1.x)

---

## 3. Prerequisites and Permissions

### 3.1 Azure Prerequisites

| Prerequisite | Description | Notes |
|--------------|-------------|-------|
| Action Groups | Must exist before deployment | IDs passed as input |
| Resource Group | Dedicated RG for alert rules | Created separately |
| Monitored Resources | Resources to monitor must exist | Template validates at apply time |
| State Storage | Azure Storage Account for Terraform state | With container created |

### 3.2 Azure RBAC Permissions

The identity running Terraform requires the following permissions:

| Scope | Role | Purpose |
|-------|------|--------|
| Alert Resource Group | Monitoring Contributor | Create/modify/delete alert rules |
| Monitored Resources | Monitoring Reader | Read metrics metadata |
| Action Groups | Reader | Reference action groups in alerts |
| State Storage Account | Storage Blob Data Contributor | Read/write state files |
| Key Vault (if used) | Key Vault Secrets User | Read secrets for webhooks |

**Minimum custom role definition (alternative to built-in roles):**

```json
{
  "Name": "PANIC Alert Deployer",
  "Actions": [
    "Microsoft.Insights/metricAlerts/*",
    "Microsoft.Insights/actionGroups/read",
    "*/read"
  ],
  "AssignableScopes": ["/subscriptions/<subscription-id>"]
}
```

### 3.3 Validation Before Apply

The template does not pre-validate that prerequisites exist. Terraform will fail at apply time if:

- Action group IDs are invalid
- Resource IDs reference non-existent resources
- Resource group does not exist
- Insufficient permissions

Recommendation: Run `terraform plan` and review before `terraform apply`.

---

## 4. Template Location

The template resides in the main PANIC repository:

```
Standard.PANIC/
├── docs/
├── bootstrap/
├── prerequisites/
├── templates/
│   └── panic-subscription-template/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       ├── backend.tf.example
│       ├── .gitignore
│       ├── terraform.tfvars.example
│       ├── vm.tf
│       ├── storage.tf
│       ├── postgresql.tf
│       ├── appservice.tf
│       ├── appgateway.tf
│       ├── vmss.tf
│       ├── disk.tf
│       ├── lb.tf
│       ├── vpngw.tf
│       ├── expressroute.tf
│       ├── firewall.tf
│       ├── sqldb.tf
│       ├── sqlmi.tf
│       ├── mysql.tf
│       ├── cosmosdb.tf
│       ├── function.tf
│       ├── keyvault.tf
│       ├── servicebus.tf
│       ├── eventhub.tf
│       ├── aks.tf
│       ├── containerapp.tf
│       ├── redis.tf
│       └── README.md
└── README.md
```

---

## 5. Usage Model

### 5.1 Deployment Workflow

1. Clone the template to a new directory or repository
2. Copy `backend.tf.example` to `backend.tf` and configure
3. Copy `terraform.tfvars.example` to `terraform.tfvars`
4. Populate `terraform.tfvars` with resource inventory
5. Enable feature switches for desired resource types
6. Run `terraform init`
7. Run `terraform plan` and review
8. Run `terraform apply`
9. Verify alerts in Azure Portal

For a detailed step-by-step checklist, see Section 14 - Cloning Checklist.

### 5.2 Scope

One template instance per subscription/environment. Each instance maintains its own Terraform state containing all alert rules for that subscription.

---

## 6. State Management

### 6.1 Strategy

Single state file per subscription/environment containing all alert rules.

### 6.2 Rationale

- Alert rules are lightweight resources with no data or complex dependencies
- Single `terraform apply` reconciles all monitoring for a subscription
- Low blast radius (worst case: alert rules are recreated, not infrastructure)
- Simple operational model for teams

### 6.3 Backend Configuration

The backend block cannot use variables. Teams must edit the backend configuration when cloning the template.

**backend.tf.example:**

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "<state-resource-group>"
    storage_account_name = "<state-storage-account>"
    container_name       = "tfstate"
    key                  = "monitoring/<subscription-name>.tfstate"
  }
}
```

---

## 7. Input Variables

### 7.1 Shared Configuration

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `subscription_id` | string | Yes | Azure subscription ID |
| `resource_group_name` | string | Yes | Resource group for alert rules |
| `action_group_ids` | map(string) | Yes | Map with `critical` and `warning` action group IDs |
| `default_profile` | string | No | Default profile for resources (default: `"standard"`) |
| `tags` | map(string) | No | Additional tags for alert rules |

**Example:**

```hcl
subscription_id     = "00000000-0000-0000-0000-000000000000"
resource_group_name = "rg-monitoring-prod"

action_group_ids = {
  critical = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Insights/actionGroups/ag-prod-critical"
  warning  = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Insights/actionGroups/ag-prod-warning"
}

default_profile = "standard"

tags = {
  environment = "production"
  managed-by  = "yourorg-cloudops"
}
```

### 7.2 Feature Switches

One boolean variable per resource type. When `false`, no resources of that type are created.

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `enable_vm_alerts` | bool | `false` | Enable Virtual Machine alerts |
| `enable_storage_alerts` | bool | `false` | Enable Storage Account alerts |
| `enable_postgresql_alerts` | bool | `false` | Enable PostgreSQL Flexible Server alerts |
| `enable_appservice_alerts` | bool | `false` | Enable App Service alerts |
| `enable_appgateway_alerts` | bool | `false` | Enable Application Gateway alerts |
| `enable_vmss_alerts` | bool | `false` | Enable Virtual Machine Scale Set alerts |
| `enable_disk_alerts` | bool | `false` | Enable Managed Disk alerts |
| `enable_lb_alerts` | bool | `false` | Enable Load Balancer alerts |
| `enable_vpngw_alerts` | bool | `false` | Enable VPN Gateway alerts |
| `enable_expressroute_alerts` | bool | `false` | Enable ExpressRoute Circuit alerts |
| `enable_firewall_alerts` | bool | `false` | Enable Azure Firewall alerts |
| `enable_sqldb_alerts` | bool | `false` | Enable Azure SQL Database alerts |
| `enable_sqlmi_alerts` | bool | `false` | Enable SQL Managed Instance alerts |
| `enable_mysql_alerts` | bool | `false` | Enable MySQL Flexible Server alerts |
| `enable_cosmosdb_alerts` | bool | `false` | Enable Cosmos DB alerts |
| `enable_function_alerts` | bool | `false` | Enable Function App alerts |
| `enable_keyvault_alerts` | bool | `false` | Enable Key Vault alerts |
| `enable_servicebus_alerts` | bool | `false` | Enable Service Bus alerts |
| `enable_eventhub_alerts` | bool | `false` | Enable Event Hub alerts |
| `enable_aks_alerts` | bool | `false` | Enable AKS alerts |
| `enable_containerapp_alerts` | bool | `false` | Enable Container App alerts |
| `enable_redis_alerts` | bool | `false` | Enable Redis Cache alerts |

### 7.3 Resource Inventory Variables

One map variable per resource type. The map key is the resource name used in alert rule naming.

**Variable names:**

| Variable | Resource Type |
|----------|---------------|
| `vms` | Virtual Machines |
| `storage_accounts` | Storage Accounts |
| `postgresql_servers` | PostgreSQL Flexible Server |
| `app_services` | App Service |
| `app_gateways` | Application Gateway |
| `vmss` | Virtual Machine Scale Sets |
| `managed_disks` | Managed Disks |
| `load_balancers` | Load Balancer |
| `vpn_gateways` | VPN Gateway |
| `expressroute_circuits` | ExpressRoute Circuit |
| `firewalls` | Azure Firewall |
| `sql_databases` | Azure SQL Database |
| `sql_managed_instances` | SQL Managed Instance |
| `mysql_servers` | MySQL Flexible Server |
| `cosmosdb_accounts` | Cosmos DB |
| `function_apps` | Function App |
| `key_vaults` | Key Vault |
| `service_bus_namespaces` | Service Bus |
| `event_hubs` | Event Hub |
| `aks_clusters` | AKS |
| `container_apps` | Container App |
| `redis_caches` | Redis Cache |

**Structure:**

```hcl
variable "vms" {
  description = "Virtual Machines to monitor"
  type = map(object({
    resource_id = string
    profile     = optional(string)
    overrides   = optional(map(any))
  }))
  default = {}
}
```

**Override structure:** The `overrides` object follows the schema defined in the PANIC modules. See the implementation guide (`docs/implementation-v2.md`, Section 9) for the full list of overridable settings per metric, including `enabled`, `warning_threshold`, `critical_threshold`, `severity_warning`, `severity_critical`, `aggregation`, `window_minutes`, `frequency_minutes`, `evaluation_periods`, and `failing_periods`.

**Example tfvars:**

```hcl
enable_vm_alerts = true

vms = {
  "yourorg-dc01" = {
    resource_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Compute/virtualMachines/yourorg-dc01"
    profile     = "critical"
  }
  "yourorg-app01" = {
    resource_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Compute/virtualMachines/yourorg-app01"
    # Inherits default_profile = "standard"
  }
  "yourorg-batch01" = {
    resource_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Compute/virtualMachines/yourorg-batch01"
    profile     = "standard"
    overrides = {
      cpu = {
        warning_threshold  = 95
        critical_threshold = 99
      }
      memory = {
        enabled = false
      }
    }
  }
}
```

### 7.4 Profile Inheritance

When a resource does not specify a `profile`, it inherits the value of `default_profile`.

Resolution order:
1. Resource-level `profile` (if specified)
2. `default_profile` variable (default: `"standard"`)

---

## 8. File Structure

### 8.1 Core Files

| File | Purpose |
|------|---------|
| `main.tf` | Provider block (see below), common data sources |
| `variables.tf` | All input variable definitions |
| `outputs.tf` | Output definitions |
| `versions.tf` | Terraform and provider version constraints (`required_version`, `required_providers`) |
| `backend.tf.example` | Backend configuration template |
| `.gitignore` | Git ignore patterns |
| `terraform.tfvars.example` | Example variable values |
| `README.md` | Usage documentation |

**main.tf provider block:**

```hcl
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
```

### 8.2 .gitignore Contents

The template includes a `.gitignore` file to prevent committing sensitive or generated files:

```gitignore
# Terraform state (stored in remote backend)
*.tfstate
*.tfstate.*

# Local overrides
terraform.tfvars
*.auto.tfvars

# Terraform working directory
.terraform/
.terraform.lock.hcl

# Backend configuration (contains environment-specific values)
backend.tf

# Crash logs
crash.log
crash.*.log

# Debug logs
terraform.log

# Sensitive variable files
*.sensitive.tfvars
secrets.tfvars
```

**Usage pattern:**

1. `backend.tf.example` → Copy to `backend.tf` (gitignored, environment-specific)
2. `terraform.tfvars.example` → Copy to `terraform.tfvars` (gitignored, contains resource inventory)

Both files are gitignored to prevent accidental commits of environment-specific configuration. The `.example` files serve as templates and are committed to the repository.

### 8.3 Resource Type Files

One file per resource type containing the module call for that type.

**Note:** The template does not call the `terraform-azurerm-monitor-base` module directly. The base module is consumed internally by each resource-specific module to create individual alert rules.

| File | Resource Type | Feature Switch | Inventory Variable |
|------|---------------|----------------|--------------------|
| `vm.tf` | Virtual Machines | `enable_vm_alerts` | `vms` |
| `storage.tf` | Storage Accounts | `enable_storage_alerts` | `storage_accounts` |
| `postgresql.tf` | PostgreSQL Flexible Server | `enable_postgresql_alerts` | `postgresql_servers` |
| `appservice.tf` | App Service | `enable_appservice_alerts` | `app_services` |
| `appgateway.tf` | Application Gateway | `enable_appgateway_alerts` | `app_gateways` |
| `vmss.tf` | Virtual Machine Scale Sets | `enable_vmss_alerts` | `vmss` |
| `disk.tf` | Managed Disks | `enable_disk_alerts` | `managed_disks` |
| `lb.tf` | Load Balancer | `enable_lb_alerts` | `load_balancers` |
| `vpngw.tf` | VPN Gateway | `enable_vpngw_alerts` | `vpn_gateways` |
| `expressroute.tf` | ExpressRoute Circuit | `enable_expressroute_alerts` | `expressroute_circuits` |
| `firewall.tf` | Azure Firewall | `enable_firewall_alerts` | `firewalls` |
| `sqldb.tf` | Azure SQL Database | `enable_sqldb_alerts` | `sql_databases` |
| `sqlmi.tf` | SQL Managed Instance | `enable_sqlmi_alerts` | `sql_managed_instances` |
| `mysql.tf` | MySQL Flexible Server | `enable_mysql_alerts` | `mysql_servers` |
| `cosmosdb.tf` | Cosmos DB | `enable_cosmosdb_alerts` | `cosmosdb_accounts` |
| `function.tf` | Function App | `enable_function_alerts` | `function_apps` |
| `keyvault.tf` | Key Vault | `enable_keyvault_alerts` | `key_vaults` |
| `servicebus.tf` | Service Bus | `enable_servicebus_alerts` | `service_bus_namespaces` |
| `eventhub.tf` | Event Hub | `enable_eventhub_alerts` | `event_hubs` |
| `aks.tf` | AKS | `enable_aks_alerts` | `aks_clusters` |
| `containerapp.tf` | Container App | `enable_containerapp_alerts` | `container_apps` |
| `redis.tf` | Redis Cache | `enable_redis_alerts` | `redis_caches` |

---

## 9. Feature Switch Implementation

Each resource type file uses `for_each` with a conditional expression that evaluates to an empty map when the feature is disabled.

**Pattern:**

```hcl
module "vm_alerts" {
  source   = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vm.git?ref=v1.0.0"
  for_each = var.enable_vm_alerts ? var.vms : {}

  resource_id         = each.value.resource_id
  resource_name       = each.key
  resource_group_name = var.resource_group_name
  profile             = coalesce(each.value.profile, var.default_profile)
  action_group_ids    = var.action_group_ids
  overrides           = each.value.overrides

  tags = var.tags
}

# Example for storage accounts (in storage.tf)
module "storage_account_alerts" {
  source   = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-storage.git?ref=v1.0.0"
  for_each = var.enable_storage_alerts ? var.storage_accounts : {}

  resource_id         = each.value.resource_id
  resource_name       = each.key
  resource_group_name = var.resource_group_name
  profile             = coalesce(each.value.profile, var.default_profile)
  action_group_ids    = var.action_group_ids
  overrides           = each.value.overrides

  tags = var.tags
}
```

**Behaviour:**

- When `enable_vm_alerts = false`: `for_each` receives `{}`, no module instances created
- When `enable_vm_alerts = true`: `for_each` iterates over `var.vms`, one module instance per resource

**Module naming convention:** `{resource_type}_alerts` based on the inventory variable name. For most resources, use the singular form (e.g., `storage_accounts` → `storage_account_alerts`, `load_balancers` → `load_balancer_alerts`). Exception: `vms` uses `vm_alerts` (not `vms_alerts`) for readability.

---

## 10. Outputs

Outputs are grouped by resource type, providing alert rule IDs for reference and downstream automation.

**Structure:**

```hcl
output "vm_alert_ids" {
  description = "Alert rule IDs for Virtual Machines"
  value       = { for k, v in module.vm_alerts : k => v.alert_ids }
}

output "storage_account_alert_ids" {
  description = "Alert rule IDs for Storage Accounts"
  value       = { for k, v in module.storage_account_alerts : k => v.alert_ids }
}

# ... repeated for all resource types
```

---

## 11. Validation

### 11.1 Profile Validation

The `default_profile` and per-resource `profile` values are validated at the variable level.

```hcl
variable "default_profile" {
  description = "Default profile for resources that do not specify one"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "critical"], var.default_profile)
    error_message = "Profile must be 'standard' or 'critical'."
  }
}
```

### 11.2 Module-Level Validation

Additional validation (resource ID format, override structure) is handled by the individual PANIC modules.

---

## 12. Secret Handling

### 12.1 Principles

| Principle | Rationale |
|-----------|----------|
| No secrets in example files | Example files are committed to version control |
| No secrets in Terraform state | State files often have broader access than intended |
| Key Vault as source of truth | Centralised, audited, access-controlled |
| Data source lookup at apply time | Secrets never written to Terraform configuration |

**Note:** While `terraform.tfvars` is gitignored and not committed, secrets should still be retrieved from Key Vault rather than stored in local files. This provides centralised management, audit trails, and easier rotation.

### 12.2 Current Scope

The template currently does not handle secrets directly. Action group IDs are Azure resource identifiers, not sensitive values. Alert rules reference these IDs without exposing credentials.

### 12.3 Potentially Sensitive Values

| Value | Sensitivity | Handling |
|-------|-------------|----------|
| Action group IDs | Not sensitive | Pass as variable |
| Webhook URLs | Sensitive | Key Vault lookup |
| API keys (external integrations) | Sensitive | Key Vault lookup |
| Notification email addresses | Low sensitivity | Pass as variable (consider privacy requirements) |

### 12.4 Key Vault Integration Pattern

When secrets are required, retrieve them via data source at apply time:

```hcl
variable "key_vault_id" {
  description = "Key Vault ID for secret retrieval (optional, required if using webhook URLs)"
  type        = string
  default     = null
}

data "azurerm_key_vault_secret" "webhook_url" {
  count        = var.key_vault_id != null ? 1 : 0
  name         = "alert-webhook-url"
  key_vault_id = var.key_vault_id
}

locals {
  webhook_url = var.key_vault_id != null ? data.azurerm_key_vault_secret.webhook_url[0].value : null
}
```

### 12.5 Guidelines

1. **Never commit secrets** - Use `.gitignore` for any local files containing sensitive values
2. **Mark sensitive outputs** - Any output containing secrets must use `sensitive = true`
3. **Minimal secret scope** - Only retrieve secrets that are actually needed
4. **Document dependencies** - If Key Vault is required, document in prerequisites
5. **Service Principal permissions** - Ensure deployment identity has Key Vault read access

---

## 13. Documentation

### 13.1 README Contents

The template README must include:

1. **Overview** - What the template does
2. **Prerequisites** - Action groups, permissions, backend storage
3. **Quick Start** - Step-by-step cloning and deployment
4. **Configuration Reference** - All variables documented
5. **Examples** - Common scenarios (single resource type, multiple types, overrides)
6. **Cloning Checklist** - Items to update when cloning

### 13.2 Example tfvars

The `terraform.tfvars.example` file provides a complete, commented example covering:

- Shared configuration
- At least one example of each resource type
- Override examples
- Profile inheritance examples

---

## 14. Cloning Checklist

When cloning the template for a new subscription, teams must:

1. [ ] Copy template to new location/repository
2. [ ] Copy `backend.tf.example` to `backend.tf`
3. [ ] Update backend configuration (storage account, state key)
4. [ ] Copy `terraform.tfvars.example` to `terraform.tfvars`
5. [ ] Set `subscription_id`
6. [ ] Set `resource_group_name` for alert rules
7. [ ] Configure `action_group_ids`
8. [ ] Enable desired feature switches
9. [ ] Populate resource inventory
10. [ ] (If using private/forked repos) Update module source URLs in resource type files
11. [ ] Run `terraform init`
12. [ ] Run `terraform plan` and review
13. [ ] Run `terraform apply`

---

## 15. Lifecycle Management

### 15.1 Adding Resources

To add monitoring for a new resource:

1. Ensure the feature switch for the resource type is enabled
2. Add the resource to the appropriate inventory variable in tfvars
3. Run `terraform plan` to verify changes
4. Run `terraform apply`

**Example - adding a new VM:**

```hcl
# Ensure this is set
enable_vm_alerts = true

# Add to existing vms map
vms = {
  # ... existing VMs ...
  
  "yourorg-newvm01" = {
    resource_id = "/subscriptions/.../resourceGroups/.../providers/Microsoft.Compute/virtualMachines/yourorg-newvm01"
    profile     = "standard"
  }
}
```

### 15.2 Updating Resources

To modify monitoring configuration:

| Change | Action |
|--------|--------|
| Change profile | Update `profile` attribute, apply |
| Add override | Add to `overrides` block, apply |
| Remove override | Remove from `overrides` block, apply |
| Change resource name | Remove old entry, add new entry (recreates alerts) |

**Note:** Changing the map key (resource name) will destroy and recreate all alerts for that resource.

### 15.3 Removing Resources

To remove monitoring for a resource:

1. Remove the resource entry from the inventory variable
2. Run `terraform plan` to verify deletions
3. Run `terraform apply`

Terraform will destroy the associated alert rules.

### 15.4 Disabling a Resource Type

To disable all alerts for a resource type:

1. Set the feature switch to `false` (e.g., `enable_vm_alerts = false`)
2. Optionally remove or comment out the inventory variable
3. Run `terraform apply`

All alerts for that resource type will be destroyed.

### 15.5 Decommissioning

To remove all monitoring for a subscription:

1. Run `terraform destroy`
2. Delete the state file from storage
3. Archive or delete the cloned template repository

### 15.6 Naming Collision Prevention

Alert rule names follow the pattern `{resource-name}-{metric}-{level}`. To avoid collisions:

- Resource names (map keys) must be unique within each resource type
- Use consistent naming conventions across resource types
- Avoid generic names like "prod" or "app" without qualifiers

**Recommended naming pattern:** `{org}-{workload}-{instance}`

Examples: `yourorg-dc01`, `yourorg-web-prod-01`, `yourorg-sqlprod`

---

## 16. Troubleshooting

### 16.1 Common Errors

| Error | Cause | Resolution |
|-------|-------|------------|
| `Resource not found` | Invalid resource ID | Verify resource exists and ID is correct |
| `Action group not found` | Invalid action group ID | Verify action group exists |
| `AuthorizationFailed` | Insufficient permissions | Check RBAC assignments (see Section 3.2 - Azure RBAC Permissions) |
| `Backend initialization failed` | State storage issue | Verify storage account, container, and permissions |
| `Invalid value for variable` | Validation failed | Check profile is "standard" or "critical" |
| `Module not found` | Git access issue | Verify network access and SSH keys/tokens |
| `Duplicate resource` | Naming collision | Ensure unique resource names in inventory |

### 16.2 State Issues

**State lock stuck:**

```bash
terraform force-unlock <lock-id>
```

**State out of sync with Azure:**

```bash
# Refresh state from Azure
terraform refresh

# Or reimport a specific resource
terraform import 'module.vm_alerts["yourorg-dc01"].azurerm_monitor_metric_alert.alert["cpu-crit"]' <resource-id>
```

**Corrupted state:**

Restore from backup in storage account (versioning should be enabled).

### 16.3 Module Issues

**Module version mismatch:**

```bash
# Clear module cache and reinitialise
rm -rf .terraform/modules
terraform init -upgrade
```

**Module source authentication:**

For private repositories, ensure:
- SSH key is configured for Git access, or
- GitHub token is available for HTTPS access

### 16.4 Debugging

**Enable Terraform debug logging:**

```bash
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log
terraform apply
```

**Validate configuration without applying:**

```bash
terraform validate
terraform plan
```

---

## 17. Future Considerations

The following items are out of scope for the initial implementation but may be addressed in future iterations:

- **Resource discovery via Azure Resource Graph** - Automated inventory population
- **Tag-based profile selection** - Read profile from resource tags
- **CI/CD pipeline templates** - Standardised deployment automation
- **Drift detection** - Scheduled validation of deployed alerts
- **Multi-subscription orchestration** - Wrapper for deploying across subscriptions

---

## 18. Summary

The `panic-subscription-template` provides a standardised method for deploying PANIC alerts across an Azure subscription. Key design decisions:

| Aspect | Decision |
|--------|----------|
| Scope | One template instance per subscription/environment |
| State | Single state file per instance |
| Structure | Modular files (one per resource type) |
| Feature switches | `for_each` conditional on boolean variable |
| Resource inventory | Flat maps in tfvars |
| Profile inheritance | Template-level default, per-resource override |
| Action groups | Passed as input (prerequisite) |
| Alert resource group | Single dedicated RG passed as variable |
| Outputs | Alert IDs grouped by resource type |
| Version constraints | Terraform >= 1.3.0, AzureRM ~> 4.0, pinned module versions |
| RBAC | Monitoring Contributor on alert RG, Monitoring Reader on resources |
| Secret handling | Key Vault lookup at apply time (no secrets in tfvars or state) |

The template balances flexibility with standardisation, enabling teams to quickly deploy consistent monitoring while supporting resource-specific customisation through the established override mechanism.
