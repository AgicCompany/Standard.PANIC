# Documentation Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix all documentation issues identified in the audit — add missing example files, correct stale references, and align docs with monorepo reality.

**Architecture:** Four independent fixes: (1) generate `examples/standard/` and `examples/critical-with-overrides/` for 19 modules missing them, (2) rename base module example to match convention, (3) fix root README repo structure diagram, (4) clarify module count phrasing. All changes are documentation/example-only — no Terraform logic changes.

**Tech Stack:** Terraform (HCL), Markdown

---

## File Map

### Examples to create (19 modules x 2 examples = 38 files)

Each file follows the same pattern established by `modules/storage/examples/` and `modules/appservice/examples/`:
- `examples/standard/main.tf` — standard profile, no overrides
- `examples/critical-with-overrides/main.tf` — critical profile with 1-2 metric overrides

Modules needing examples:
`vm`, `postgresql`, `aks`, `containerapp`, `cosmosdb`, `disk`, `eventhub`, `expressroute`, `firewall`, `function`, `keyvault`, `lb`, `mysql`, `redis`, `servicebus`, `sqldb`, `sqlmi`, `vpngw`, `appgateway`

### Files to modify

- `README.md` — fix repo structure diagram
- `docs/modules.md` — clarify module count
- `modules/base/examples/basic/main.tf` — move to `modules/base/examples/standard/main.tf`

### Data source reference per module

Each example needs the correct `data` source. Mapping:

| Module | Data Source | Resource Type |
|--------|-----------|---------------|
| vm | `azurerm_linux_virtual_machine` | `Microsoft.Compute/virtualMachines` |
| postgresql | `azurerm_postgresql_flexible_server` | `Microsoft.DBforPostgreSQL/flexibleServers` |
| aks | `azurerm_kubernetes_cluster` | `Microsoft.ContainerService/managedClusters` |
| containerapp | `azurerm_container_app` | `Microsoft.App/containerApps` |
| cosmosdb | `azurerm_cosmosdb_account` | `Microsoft.DocumentDB/databaseAccounts` |
| disk | `azurerm_managed_disk` | `Microsoft.Compute/disks` |
| eventhub | `azurerm_eventhub_namespace` | `Microsoft.EventHub/namespaces` |
| expressroute | `azurerm_express_route_circuit` | `Microsoft.Network/expressRouteCircuits` |
| firewall | `azurerm_firewall` | `Microsoft.Network/azureFirewalls` |
| function | `azurerm_linux_function_app` | `Microsoft.Web/sites` |
| keyvault | `azurerm_key_vault` | `Microsoft.KeyVault/vaults` |
| lb | `azurerm_lb` | `Microsoft.Network/loadBalancers` |
| mysql | `azurerm_mysql_flexible_server` | `Microsoft.DBforMySQL/flexibleServers` |
| redis | `azurerm_redis_cache` | `Microsoft.Cache/Redis` |
| servicebus | `azurerm_servicebus_namespace` | `Microsoft.ServiceBus/namespaces` |
| sqldb | `azurerm_mssql_database` | `Microsoft.Sql/servers/databases` |
| sqlmi | `azurerm_mssql_managed_instance` | `Microsoft.Sql/managedInstances` |
| vpngw | `azurerm_virtual_network_gateway` | `Microsoft.Network/virtualNetworkGateways` |
| appgateway | `azurerm_application_gateway` | `Microsoft.Network/applicationGateways` |

---

### Task 1: Add examples for vm module

**Files:**
- Create: `modules/vm/examples/standard/main.tf`
- Create: `modules/vm/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

```hcl
provider "azurerm" {
  features {}
}

data "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm"
  resource_group_name = "rg-example"
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
  source = "../../"

  resource_id         = data.azurerm_linux_virtual_machine.example.id
  resource_name       = "dev-vm-01"
  resource_group_name = "rg-monitoring-dev"
  profile             = "standard"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  tags = {
    environment = "development"
  }
}

output "alert_ids" {
  value = module.vm_alerts.alert_ids
}
```

- [ ] **Step 2: Create critical-with-overrides example**

```hcl
provider "azurerm" {
  features {}
}

data "azurerm_linux_virtual_machine" "production" {
  name                = "prod-db-01"
  resource_group_name = "rg-production"
}

data "azurerm_monitor_action_group" "critical" {
  name                = "ag-prod-critical"
  resource_group_name = "rg-monitoring-prod"
}

data "azurerm_monitor_action_group" "warning" {
  name                = "ag-prod-warning"
  resource_group_name = "rg-monitoring-prod"
}

module "vm_alerts" {
  source = "../../"

  resource_id         = data.azurerm_linux_virtual_machine.production.id
  resource_name       = "prod-db-01"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  overrides = {
    cpu = {
      warning_threshold  = 70
      critical_threshold = 85
    }
    memory = {
      enabled = true
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.vm_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.vm_alerts.resolved_thresholds
}
```

- [ ] **Step 3: Commit**

```bash
git add modules/vm/examples/
git commit -m "Add examples for vm module"
```

---

### Task 2: Add examples for postgresql module

**Files:**
- Create: `modules/postgresql/examples/standard/main.tf`
- Create: `modules/postgresql/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_postgresql_flexible_server"`, module name `postgresql_alerts`, resource name `"dev-pgsql-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-pgsql-01"`, overrides for `cpu` (warning: 70, critical: 85) and `storage` (warning: 75, critical: 90).

- [ ] **Step 3: Commit**

```bash
git add modules/postgresql/examples/
git commit -m "Add examples for postgresql module"
```

---

### Task 3: Add examples for aks module

**Files:**
- Create: `modules/aks/examples/standard/main.tf`
- Create: `modules/aks/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_kubernetes_cluster"`, module name `aks_alerts`, resource name `"dev-aks-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-aks-01"`, overrides for `node_count` (enabled: true, warning: 5, critical: 3) and `node_cpu` (warning: 60, critical: 80).

- [ ] **Step 3: Commit**

```bash
git add modules/aks/examples/
git commit -m "Add examples for aks module"
```

---

### Task 4: Add examples for containerapp module

**Files:**
- Create: `modules/containerapp/examples/standard/main.tf`
- Create: `modules/containerapp/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_container_app"`, module name `containerapp_alerts`, resource name `"dev-capp-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-capp-api"`, overrides for `cpu` (warning: 70, critical: 85) and `replica_count` (enabled: true).

- [ ] **Step 3: Commit**

```bash
git add modules/containerapp/examples/
git commit -m "Add examples for containerapp module"
```

---

### Task 5: Add examples for cosmosdb module

**Files:**
- Create: `modules/cosmosdb/examples/standard/main.tf`
- Create: `modules/cosmosdb/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_cosmosdb_account"`, module name `cosmosdb_alerts`, resource name `"dev-cosmos-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-cosmos-01"`, overrides for `ru_consumption` (warning: 70, critical: 85) and `server_latency` (warning: 5, critical: 10).

- [ ] **Step 3: Commit**

```bash
git add modules/cosmosdb/examples/
git commit -m "Add examples for cosmosdb module"
```

---

### Task 6: Add examples for disk module

**Files:**
- Create: `modules/disk/examples/standard/main.tf`
- Create: `modules/disk/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_managed_disk"`, module name `disk_alerts`, resource name `"dev-disk-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-disk-data"`, overrides for `iops_consumed` (warning: 80, critical: 95).

- [ ] **Step 3: Commit**

```bash
git add modules/disk/examples/
git commit -m "Add examples for disk module"
```

---

### Task 7: Add examples for eventhub module

**Files:**
- Create: `modules/eventhub/examples/standard/main.tf`
- Create: `modules/eventhub/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_eventhub_namespace"`, module name `eventhub_alerts`, resource name `"dev-eh-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-eh-ingest"`, overrides for `throttled_requests` (warning: 1, critical: 5) and `incoming_messages` (warning: 80, critical: 90).

- [ ] **Step 3: Commit**

```bash
git add modules/eventhub/examples/
git commit -m "Add examples for eventhub module"
```

---

### Task 8: Add examples for expressroute module

**Files:**
- Create: `modules/expressroute/examples/standard/main.tf`
- Create: `modules/expressroute/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_express_route_circuit"`, module name `expressroute_alerts`, resource name `"dev-er-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-er-primary"`, overrides for `bgp_availability` (warning: 99.9, critical: 99).

- [ ] **Step 3: Commit**

```bash
git add modules/expressroute/examples/
git commit -m "Add examples for expressroute module"
```

---

### Task 9: Add examples for firewall module

**Files:**
- Create: `modules/firewall/examples/standard/main.tf`
- Create: `modules/firewall/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_firewall"`, module name `firewall_alerts`, resource name `"dev-fw-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-fw-hub"`, overrides for `health_state` (warning: 95, critical: 90).

- [ ] **Step 3: Commit**

```bash
git add modules/firewall/examples/
git commit -m "Add examples for firewall module"
```

---

### Task 10: Add examples for function module

**Files:**
- Create: `modules/function/examples/standard/main.tf`
- Create: `modules/function/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_linux_function_app"`, module name `function_alerts`, resource name `"dev-func-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-func-processor"`, overrides for `http_5xx` (warning: 1, critical: 5) and `response_time` (warning: 500, critical: 1000).

- [ ] **Step 3: Commit**

```bash
git add modules/function/examples/
git commit -m "Add examples for function module"
```

---

### Task 11: Add examples for keyvault module

**Files:**
- Create: `modules/keyvault/examples/standard/main.tf`
- Create: `modules/keyvault/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_key_vault"`, module name `keyvault_alerts`, resource name `"dev-kv-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-kv-secrets"`, overrides for `availability` (warning: 99.9, critical: 99) and `latency` (warning: 500, critical: 1000).

- [ ] **Step 3: Commit**

```bash
git add modules/keyvault/examples/
git commit -m "Add examples for keyvault module"
```

---

### Task 12: Add examples for lb module

**Files:**
- Create: `modules/lb/examples/standard/main.tf`
- Create: `modules/lb/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_lb"`, module name `lb_alerts`, resource name `"dev-lb-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-lb-frontend"`, overrides for `health_probe_status` (warning: 95, critical: 90).

- [ ] **Step 3: Commit**

```bash
git add modules/lb/examples/
git commit -m "Add examples for lb module"
```

---

### Task 13: Add examples for mysql module

**Files:**
- Create: `modules/mysql/examples/standard/main.tf`
- Create: `modules/mysql/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_mysql_flexible_server"`, module name `mysql_alerts`, resource name `"dev-mysql-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-mysql-app"`, overrides for `cpu` (warning: 70, critical: 85) and `storage` (warning: 75, critical: 90).

- [ ] **Step 3: Commit**

```bash
git add modules/mysql/examples/
git commit -m "Add examples for mysql module"
```

---

### Task 14: Add examples for redis module

**Files:**
- Create: `modules/redis/examples/standard/main.tf`
- Create: `modules/redis/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_redis_cache"`, module name `redis_alerts`, resource name `"dev-redis-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-redis-session"`, overrides for `server_load` (warning: 70, critical: 85) and `cache_miss_rate` (enabled: true).

- [ ] **Step 3: Commit**

```bash
git add modules/redis/examples/
git commit -m "Add examples for redis module"
```

---

### Task 15: Add examples for servicebus module

**Files:**
- Create: `modules/servicebus/examples/standard/main.tf`
- Create: `modules/servicebus/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_servicebus_namespace"`, module name `servicebus_alerts`, resource name `"dev-sb-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-sb-orders"`, overrides for `active_messages` (warning: 500, critical: 1000) and `dead_letter_messages` (warning: 10, critical: 50).

- [ ] **Step 3: Commit**

```bash
git add modules/servicebus/examples/
git commit -m "Add examples for servicebus module"
```

---

### Task 16: Add examples for sqldb module

**Files:**
- Create: `modules/sqldb/examples/standard/main.tf`
- Create: `modules/sqldb/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_mssql_database"`, module name `sqldb_alerts`, resource name `"dev-sqldb-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-sqldb-app"`, overrides for `cpu` (warning: 70, critical: 85) and `deadlocks` (warning: 1, critical: 5).

- [ ] **Step 3: Commit**

```bash
git add modules/sqldb/examples/
git commit -m "Add examples for sqldb module"
```

---

### Task 17: Add examples for sqlmi module

**Files:**
- Create: `modules/sqlmi/examples/standard/main.tf`
- Create: `modules/sqlmi/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_mssql_managed_instance"`, module name `sqlmi_alerts`, resource name `"dev-sqlmi-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-sqlmi-erp"`, overrides for `cpu` (warning: 70, critical: 85) and `storage` (warning: 75, critical: 90).

- [ ] **Step 3: Commit**

```bash
git add modules/sqlmi/examples/
git commit -m "Add examples for sqlmi module"
```

---

### Task 18: Add examples for vpngw module

**Files:**
- Create: `modules/vpngw/examples/standard/main.tf`
- Create: `modules/vpngw/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_virtual_network_gateway"`, module name `vpngw_alerts`, resource name `"dev-vpngw-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-vpngw-hub"`, overrides for `tunnel_status` (warning: 1, critical: 0).

- [ ] **Step 3: Commit**

```bash
git add modules/vpngw/examples/
git commit -m "Add examples for vpngw module"
```

---

### Task 19: Add examples for appgateway module

**Files:**
- Create: `modules/appgateway/examples/standard/main.tf`
- Create: `modules/appgateway/examples/critical-with-overrides/main.tf`

- [ ] **Step 1: Create standard example**

Use `data "azurerm_application_gateway"`, module name `appgateway_alerts`, resource name `"dev-agw-01"`.

- [ ] **Step 2: Create critical-with-overrides example**

Use resource name `"prod-agw-frontend"`, overrides for `unhealthy_host_count` (warning: 1, critical: 3) and `response_status` (warning: 10, critical: 50).

- [ ] **Step 3: Commit**

```bash
git add modules/appgateway/examples/
git commit -m "Add examples for appgateway module"
```

---

### Task 20: Rename base module example to match convention

**Files:**
- Delete: `modules/base/examples/basic/main.tf`
- Create: `modules/base/examples/standard/main.tf` (same content)

- [ ] **Step 1: Move example directory**

```bash
cd /home/molaru/projects/panic-az-mon-framework
git mv modules/base/examples/basic modules/base/examples/standard
```

- [ ] **Step 2: Commit**

```bash
git add modules/base/examples/
git commit -m "Rename base module example to match convention"
```

---

### Task 21: Fix root README repo structure diagram

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update the repo structure block**

Change:
```
Standard.PANIC/
├── docs/                 # Documentation
├── templates/            # Deployment templates
│   └── panic-subscription-template/  # Full subscription monitoring
├── bootstrap/            # Terraform state backend setup
├── prerequisites/        # Log Analytics + Action Groups
└── deployments/          # Example alert deployments
```

To:
```
Standard.PANIC/
├── modules/              # Alert modules (22 resource types)
├── docs/                 # Documentation
├── templates/            # Deployment templates
│   └── panic-subscription-template/  # Full subscription monitoring
├── bootstrap/            # Terraform state backend setup
├── prerequisites/        # Log Analytics + Action Groups
└── deployments/          # Example alert deployments
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "Add modules/ to repo structure diagram"
```

---

### Task 22: Clarify module count in docs

**Files:**
- Modify: `README.md`
- Modify: `docs/modules.md`

- [ ] **Step 1: Update README.md**

Change:
```
Standardized alerting across 22 Azure resource types.
```
To:
```
Standardized alerting across 21 Azure resource types, plus a shared base module.
```

- [ ] **Step 2: Update docs/modules.md**

Change:
```
PANIC provides monitoring modules for 22 Azure resource types.
```
To:
```
PANIC provides 22 monitoring modules: 21 resource-specific modules plus a shared base module.
```

- [ ] **Step 3: Commit**

```bash
git add README.md docs/modules.md
git commit -m "Clarify module count phrasing in docs"
```

---

### Task 23: Final push

- [ ] **Step 1: Push all commits to both remotes**

```bash
git push origin main
git push agic main
```

- [ ] **Step 2: Update per-module tags for modules that gained examples**

```bash
# Tags should be updated to include the new example files
for mod in vm postgresql aks containerapp cosmosdb disk eventhub expressroute firewall function keyvault lb mysql redis servicebus sqldb sqlmi vpngw appgateway base; do
  git tag -f "${mod}-v1.0.0" -m "Initial monorepo release for ${mod} module"
done
git push origin --tags --force
git push agic --tags --force
```
