# Azure Monitoring Framework - Implementation Guide

## Document Information

| Attribute | Value |
|-----------|-------|
| Version | 1.1 |
| Status | Draft |
| Last Updated | 2024-12 |

---

## 1. Introduction

This document defines the implementation details for deploying the Azure Monitoring Framework. It complements the concept document by specifying tooling, module structure, thresholds, and operational parameters.

The framework provides a standardised, profile-based approach to metric alerting across Azure resources using Terraform.

---

## 2. Scope

### 2.1 Version 1 Resources

The following resource types are in scope for the initial implementation:

| Resource Type | Module Repository |
|---------------|-------------------|
| Virtual Machines (Windows/Linux) | `terraform-azurerm-monitor-vm` |
| PostgreSQL Flexible Server | `terraform-azurerm-monitor-postgresql` |
| Storage Account | `terraform-azurerm-monitor-storage` |
| App Service | `terraform-azurerm-monitor-appservice` |
| Application Gateway | `terraform-azurerm-monitor-appgateway` |

### 2.2 Version 2 Resources

The following resource types are planned for the second release.

**IaaS Resources:**

| Resource Type | Module Repository |
|---------------|-------------------|
| Virtual Machine Scale Sets | `terraform-azurerm-monitor-vmss` |
| Managed Disks | `terraform-azurerm-monitor-disk` |
| Load Balancer | `terraform-azurerm-monitor-lb` |
| VPN Gateway | `terraform-azurerm-monitor-vpngw` |
| ExpressRoute Circuit | `terraform-azurerm-monitor-expressroute` |
| Azure Firewall | `terraform-azurerm-monitor-firewall` |

**PaaS Resources:**

| Resource Type | Module Repository |
|---------------|-------------------|
| Azure SQL Database | `terraform-azurerm-monitor-sqldb` |
| Azure SQL Managed Instance | `terraform-azurerm-monitor-sqlmi` |
| MySQL Flexible Server | `terraform-azurerm-monitor-mysql` |
| Cosmos DB | `terraform-azurerm-monitor-cosmosdb` |
| Function App | `terraform-azurerm-monitor-function` |
| Key Vault | `terraform-azurerm-monitor-keyvault` |
| Service Bus | `terraform-azurerm-monitor-servicebus` |
| Event Hub | `terraform-azurerm-monitor-eventhub` |
| AKS | `terraform-azurerm-monitor-aks` |
| Container App | `terraform-azurerm-monitor-containerapp` |
| Redis Cache | `terraform-azurerm-monitor-redis` |

---

## 3. Prerequisites

The following components are out of scope for the monitoring modules and must exist prior to deployment.

### 3.1 Required Inputs

| Component | Description | Passed As |
|-----------|-------------|-----------|
| Log Analytics Workspace ID | Destination for DCR data | Module variable |
| Action Group IDs | Notification routing | Module variable (map) |

### 3.2 Infrastructure Dependencies

| Component | Purpose | Notes |
|-----------|---------|-------|
| Azure Monitor Agent | Guest metrics collection | Required for VM memory and disk metrics |
| Data Collection Rules | Guest metric routing | Must target Log Analytics Workspace |
| Action Groups | Alert notifications | Created separately, IDs passed to modules |

---

## 4. Tooling and Architecture

### 4.1 Tooling

| Component | Choice |
|-----------|--------|
| Infrastructure as Code | Terraform |
| Provider | azurerm |
| State Backend | Remote (Azure Storage Account) |

### 4.2 Deployment Model

Alerts are deployed as a separate monitoring layer, decoupled from resource provisioning. This allows:

- Independent lifecycle management
- Centralised monitoring configuration
- Consistent alerting across resources deployed by different teams

### 4.3 Repository Structure

Each module resides in its own repository to enable independent versioning.

**V1 Repositories:**

| Repository | Purpose |
|------------|---------|
| `terraform-azurerm-monitor-base` | Base alert module (creates individual metric alerts) |
| `terraform-azurerm-monitor-vm` | Virtual Machine alerts |
| `terraform-azurerm-monitor-postgresql` | PostgreSQL Flexible Server alerts |
| `terraform-azurerm-monitor-storage` | Storage Account alerts |
| `terraform-azurerm-monitor-appservice` | App Service alerts |
| `terraform-azurerm-monitor-appgateway` | Application Gateway alerts |

**V2 Repositories:**

| Repository | Purpose |
|------------|---------|
| `terraform-azurerm-monitor-vmss` | Virtual Machine Scale Sets alerts |
| `terraform-azurerm-monitor-disk` | Managed Disks alerts |
| `terraform-azurerm-monitor-lb` | Load Balancer alerts |
| `terraform-azurerm-monitor-vpngw` | VPN Gateway alerts |
| `terraform-azurerm-monitor-expressroute` | ExpressRoute Circuit alerts |
| `terraform-azurerm-monitor-firewall` | Azure Firewall alerts |
| `terraform-azurerm-monitor-sqldb` | Azure SQL Database alerts |
| `terraform-azurerm-monitor-sqlmi` | Azure SQL Managed Instance alerts |
| `terraform-azurerm-monitor-mysql` | MySQL Flexible Server alerts |
| `terraform-azurerm-monitor-cosmosdb` | Cosmos DB alerts |
| `terraform-azurerm-monitor-function` | Function App alerts |
| `terraform-azurerm-monitor-keyvault` | Key Vault alerts |
| `terraform-azurerm-monitor-servicebus` | Service Bus alerts |
| `terraform-azurerm-monitor-eventhub` | Event Hub alerts |
| `terraform-azurerm-monitor-aks` | AKS alerts |
| `terraform-azurerm-monitor-containerapp` | Container App alerts |
| `terraform-azurerm-monitor-redis` | Redis Cache alerts |

### 4.4 Module Structure

Each resource-specific module follows this pattern:

```
terraform-azurerm-monitor-{resource}/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── profiles.tf          # Profile definitions
├── defaults.tf          # Alert defaults
├── versions.tf
└── examples/
    ├── standard/
    │   └── main.tf
    └── critical-with-overrides/
        └── main.tf
```

### 4.5 Versioning

Modules are versioned using Git tags following semantic versioning.

```hcl
module "vm_alerts" {
  source = "git::https://github.com/yourorg/terraform-azurerm-monitor-vm.git?ref=v1.0.0"
  # ...
}
```

---

## 5. Profiles

### 5.1 Profile Definitions

| Profile | Intent |
|---------|--------|
| Standard | Default for most resources. Balanced thresholds, moderate severities. |
| Critical | For high-value or business-critical resources. Tighter thresholds, higher severities. |

### 5.2 Profile Selection

Profile selection is made at deployment time via module input:

```hcl
module "vm_alerts" {
  source  = "git::https://github.com/yourorg/terraform-azurerm-monitor-vm.git?ref=v1.0.0"
  
  resource_id    = azurerm_virtual_machine.example.id
  resource_name  = "yourorg-dc01"
  profile        = "critical"
  action_group_ids = {
    critical = azurerm_monitor_action_group.prod_critical.id
    warning  = azurerm_monitor_action_group.prod_warning.id
  }
}
```

---

## 6. Alert Defaults

The following defaults apply to all alerts unless overridden.

| Setting | Default | Description |
|---------|---------|-------------|
| Aggregation | Average | Override to Max for burst metrics, Min for availability |
| Frequency | 1 minute | How often the rule evaluates |
| Window | Per metric | 1 min (availability), 5 min (default), 15 min (capacity) |
| Evaluation Periods (Sev 1) | 1 of 1 | Immediate alerting for critical conditions |
| Evaluation Periods (Sev 2) | 3 of 5 | Sustained condition required for warnings |
| Auto-resolve | true | Alert closes when condition clears |
| Auto-mitigate | true | Prevents duplicate alerts for same condition |

---

## 7. Thresholds - Version 1 Resources

### 7.1 Virtual Machines

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window |
|--------|---------------|---------------|---------------|---------------|--------|
| CPU % | 85 | 95 | 75 | 90 | 5 min |
| Available Memory % | 15 | 10 | 20 | 15 | 5 min |
| OS Disk IOPS % | 85 | 95 | 75 | 90 | 5 min |
| Data Disk IOPS % | 85 | 95 | 75 | 90 | 5 min |
| Logical Disk Free % | 15 | 10 | 20 | 15 | 15 min |
| VM Availability | — | < 1 | — | < 1 | 1 min |

Note: Memory and Disk Free % thresholds are inverted (lower values indicate worse conditions).

### 7.2 PostgreSQL Flexible Server

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window |
|--------|---------------|---------------|---------------|---------------|--------|
| CPU % | 80 | 95 | 70 | 90 | 5 min |
| Memory % | 80 | 95 | 70 | 90 | 5 min |
| Storage % | 80 | 90 | 70 | 85 | 15 min |
| Active Connections % | 80 | 90 | 70 | 85 | 5 min |
| Failed Connections | 10 | 50 | 5 | 25 | 5 min |
| Is DB Alive | — | < 1 | — | < 1 | 1 min |
| Replication Lag (sec) | 30 | 60 | 10 | 30 | 5 min |

### 7.3 Storage Account

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window |
|--------|---------------|---------------|---------------|---------------|--------|
| Availability % | 99.9 | 99 | 99.95 | 99.5 | 5 min |
| E2E Latency (ms) | 500 | 1000 | 250 | 500 | 5 min |
| Throttling (errors) | 10 | 100 | 5 | 50 | 5 min |
| Used Capacity % | 80 | 90 | 70 | 85 | 15 min |

### 7.4 App Service

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window |
|--------|---------------|---------------|---------------|---------------|--------|
| CPU % | 80 | 95 | 70 | 90 | 5 min |
| Memory % | 80 | 95 | 70 | 90 | 5 min |
| HTTP 5xx (count) | 10 | 50 | 5 | 25 | 5 min |
| Response Time (ms) | 2000 | 5000 | 1000 | 3000 | 5 min |
| Health Check Status | — | < 1 | — | < 1 | 1 min |

### 7.5 Application Gateway

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window |
|--------|---------------|---------------|---------------|---------------|--------|
| Unhealthy Host Count | 1 | 2 | 1 | 1 | 1 min |
| Backend Response Status 5xx | 10 | 50 | 5 | 25 | 5 min |
| CPU % | 80 | 95 | 70 | 90 | 5 min |
| Capacity Units | 80% of provisioned | 95% | 70% | 85% | 5 min |
| Failed Requests | 10 | 50 | 5 | 25 | 5 min |
| Response Status 5xx | 10 | 50 | 5 | 25 | 5 min |

---

## 8. Thresholds - Version 2 Resources

### 8.1 IaaS Resources

#### 8.1.1 Virtual Machine Scale Sets

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| CPU % (Average) | 85 | 95 | 75 | 90 | 5 min | Across all instances |
| Available Memory % | 15 | 10 | 20 | 15 | 5 min | Requires AMA |
| OS Disk IOPS % | 85 | 95 | 75 | 90 | 5 min | |
| Data Disk IOPS % | 85 | 95 | 75 | 90 | 5 min | |
| Logical Disk Free % | 15 | 10 | 20 | 15 | 15 min | Requires AMA |
| Unhealthy Instance Count | 1 | 2 | 1 | 1 | 1 min | |

#### 8.1.2 Managed Disks

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| IOPS Consumed % | 85 | 95 | 75 | 90 | 5 min | |
| Bandwidth Consumed % | 85 | 95 | 75 | 90 | 5 min | Throughput |
| Queue Depth | 32 | 64 | 16 | 32 | 5 min | Indicates saturation |
| Burst BPS Credits % | 20 | 10 | 30 | 20 | 5 min | Lower is worse |
| Burst IO Credits % | 20 | 10 | 30 | 20 | 5 min | Lower is worse |

#### 8.1.3 Load Balancer

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Health Probe Status | — | < 1 | — | < 1 | 1 min | Per backend pool |
| Data Path Availability % | 99.9 | 99 | 99.95 | 99.5 | 1 min | |
| SNAT Connection Count | 80% of limit | 95% of limit | 70% | 90% | 5 min | |
| Used SNAT Ports % | 80 | 95 | 70 | 90 | 5 min | |
| Allocated SNAT Ports | — | — | — | — | — | Informational only |

#### 8.1.4 VPN Gateway

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Tunnel Status | — | < 1 | — | < 1 | 1 min | Per tunnel |
| Tunnel Bandwidth (Mbps) | 80% of SKU limit | 95% | 70% | 90% | 5 min | |
| Tunnel Egress Bytes | — | — | — | — | — | Informational only |
| Tunnel Ingress Bytes | — | — | — | — | — | Informational only |
| Gateway P2S Bandwidth | 80% of SKU limit | 95% | 70% | 90% | 5 min | |
| P2S Connection Count | 80% of limit | 95% | 70% | 90% | 5 min | |
| Tunnel Drop Count | 5 | 20 | 2 | 10 | 5 min | |

#### 8.1.5 ExpressRoute Circuit

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| BGP Availability % | 99.9 | 99 | 99.95 | 99.5 | 1 min | |
| ARP Availability % | 99.9 | 99 | 99.95 | 99.5 | 1 min | |
| Bits In Per Second | 80% of bandwidth | 95% | 70% | 90% | 5 min | |
| Bits Out Per Second | 80% of bandwidth | 95% | 70% | 90% | 5 min | |
| Dropped Packets In | 10 | 100 | 5 | 50 | 5 min | |
| Dropped Packets Out | 10 | 100 | 5 | 50 | 5 min | |
| Global Reach Bits In | 80% of bandwidth | 95% | 70% | 90% | 5 min | If applicable |
| Global Reach Bits Out | 80% of bandwidth | 95% | 70% | 90% | 5 min | If applicable |

#### 8.1.6 Azure Firewall

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Firewall Health State % | 99 | 95 | 99.5 | 99 | 1 min | |
| Throughput (bps) | 80% of SKU limit | 95% | 70% | 90% | 5 min | |
| SNAT Port Utilisation % | 80 | 95 | 70 | 90 | 5 min | |
| Data Processed (GB) | — | — | — | — | — | Informational/cost |
| Application Rule Hit Count | — | — | — | — | — | Informational only |
| Network Rule Hit Count | — | — | — | — | — | Informational only |
| Latency Probe (ms) | 20 | 50 | 10 | 30 | 5 min | |

### 8.2 PaaS Resources

#### 8.2.1 Azure SQL Database

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| DTU Percentage | 80 | 95 | 70 | 90 | 5 min | DTU model |
| CPU Percentage | 80 | 95 | 70 | 90 | 5 min | vCore model |
| Data IO Percentage | 80 | 95 | 70 | 90 | 5 min | |
| Log IO Percentage | 80 | 95 | 70 | 90 | 5 min | |
| Storage Percentage | 80 | 90 | 70 | 85 | 15 min | |
| Workers Percentage | 80 | 95 | 70 | 90 | 5 min | |
| Sessions Percentage | 80 | 95 | 70 | 90 | 5 min | |
| Deadlocks | 5 | 20 | 2 | 10 | 5 min | |
| Failed Connections | 10 | 50 | 5 | 25 | 5 min | |
| Blocked By Firewall | 5 | 20 | 2 | 10 | 5 min | |

#### 8.2.2 Azure SQL Managed Instance

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Average CPU % | 80 | 95 | 70 | 90 | 5 min | |
| Storage Space Used % | 80 | 90 | 70 | 85 | 15 min | |
| IO Requests | — | — | — | — | — | Baseline-dependent |
| IO Bytes Read/Written | — | — | — | — | — | Baseline-dependent |
| Reserved Storage (MB) | 80% of limit | 95% | 70% | 90% | 15 min | |
| Virtual Core Count | — | — | — | — | — | Informational |

#### 8.2.3 MySQL Flexible Server

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| CPU % | 80 | 95 | 70 | 90 | 5 min | |
| Memory % | 80 | 95 | 70 | 90 | 5 min | |
| Storage % | 80 | 90 | 70 | 85 | 15 min | |
| IO % | 80 | 95 | 70 | 90 | 5 min | |
| Active Connections | 80% of limit | 95% | 70% | 90% | 5 min | |
| Aborted Connections | 10 | 50 | 5 | 25 | 5 min | |
| Is DB Alive | — | < 1 | — | < 1 | 1 min | |
| Replication Lag (sec) | 30 | 60 | 10 | 30 | 5 min | Read replicas |
| Total Connections | — | — | — | — | — | Informational |

#### 8.2.4 Cosmos DB

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Normalised RU Consumption % | 80 | 95 | 70 | 90 | 5 min | Per partition |
| Total Request Units | — | — | — | — | — | Baseline-dependent |
| Service Availability % | 99.9 | 99 | 99.99 | 99.9 | 1 min | |
| Server Side Latency (ms) | 10 | 50 | 5 | 20 | 5 min | |
| Data Usage (bytes) | 80% of limit | 95% | 70% | 90% | 15 min | |
| Index Usage (bytes) | 80% of limit | 95% | 70% | 90% | 15 min | |
| Total Requests 429 | 10 | 100 | 5 | 50 | 5 min | Throttled requests |
| Metadata Requests | — | — | — | — | — | Informational |
| Autoscale Max Throughput | — | — | — | — | — | Informational |

#### 8.2.5 Function App

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Function Execution Count | — | — | — | — | — | Baseline-dependent |
| Function Execution Units | — | — | — | — | — | Consumption plan |
| Execution Failures | 10 | 50 | 5 | 25 | 5 min | |
| Execution Duration (ms) | 30000 | 60000 | 15000 | 30000 | 5 min | Near timeout |
| Memory Working Set (MB) | 80% of limit | 95% | 70% | 90% | 5 min | |
| Connections | 80% of limit | 95% | 70% | 90% | 5 min | |
| HTTP 5xx | 10 | 50 | 5 | 25 | 5 min | |
| HTTP Response Time (ms) | 2000 | 5000 | 1000 | 3000 | 5 min | |
| Thread Count | — | — | — | — | — | Informational |

#### 8.2.6 Key Vault

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Service API Availability % | 99.9 | 99 | 99.95 | 99.5 | 1 min | |
| Service API Latency (ms) | 500 | 1000 | 250 | 500 | 5 min | |
| Total Service API Hits | — | — | — | — | — | Baseline-dependent |
| Service API Results (429) | 10 | 100 | 5 | 50 | 5 min | Throttled |
| Saturation Shoebox % | 80 | 95 | 70 | 90 | 5 min | Vault capacity |

#### 8.2.7 Service Bus

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Active Messages | 10000 | 50000 | 5000 | 25000 | 5 min | Queue depth |
| Dead-lettered Messages | 100 | 500 | 50 | 200 | 5 min | Poison messages |
| Scheduled Messages | — | — | — | — | — | Informational |
| Messages | — | — | — | — | — | Total count |
| Active Connections | 80% of limit | 95% | 70% | 90% | 5 min | |
| Server Errors | 10 | 50 | 5 | 25 | 5 min | |
| User Errors | 50 | 200 | 25 | 100 | 5 min | Client-side issues |
| Throttled Requests | 10 | 100 | 5 | 50 | 5 min | |
| Size (bytes) | 80% of quota | 95% | 70% | 90% | 15 min | Namespace size |
| CPU % | 80 | 95 | 70 | 90 | 5 min | Premium tier |
| Memory % | 80 | 95 | 70 | 90 | 5 min | Premium tier |

#### 8.2.8 Event Hub

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Incoming Messages | — | — | — | — | — | Baseline-dependent |
| Outgoing Messages | — | — | — | — | — | Baseline-dependent |
| Incoming Bytes | 80% of TU limit | 95% | 70% | 90% | 5 min | |
| Outgoing Bytes | 80% of TU limit | 95% | 70% | 90% | 5 min | |
| Throttled Requests | 10 | 100 | 5 | 50 | 5 min | |
| Quota Exceeded Errors | 1 | 10 | 1 | 5 | 5 min | |
| Server Errors | 10 | 50 | 5 | 25 | 5 min | |
| User Errors | 50 | 200 | 25 | 100 | 5 min | |
| Active Connections | 80% of limit | 95% | 70% | 90% | 5 min | |
| Capture Backlog | 10000 | 100000 | 5000 | 50000 | 5 min | If capture enabled |
| Captured Messages | — | — | — | — | — | Informational |

#### 8.2.9 AKS

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Node CPU % | 80 | 95 | 70 | 90 | 5 min | |
| Node Memory % | 80 | 95 | 70 | 90 | 5 min | |
| Node Disk % | 80 | 90 | 70 | 85 | 15 min | |
| Node Not Ready Count | 1 | 2 | 1 | 1 | 1 min | |
| Pod Count | 80% of limit | 95% | 70% | 90% | 5 min | Per node |
| Pod Failed Count | 1 | 5 | 1 | 2 | 5 min | |
| Pod Pending Count | 5 | 20 | 2 | 10 | 5 min | Scheduling issues |
| Cluster Health | — | < 1 | — | < 1 | 1 min | |
| Kube API Server Requests (429) | 10 | 50 | 5 | 25 | 5 min | Throttled |
| PV Usage % | 80 | 90 | 70 | 85 | 15 min | Persistent volumes |

#### 8.2.10 Container App

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| CPU % | 80 | 95 | 70 | 90 | 5 min | |
| Memory % | 80 | 95 | 70 | 90 | 5 min | |
| Replica Count | — | 0 | — | 0 | 1 min | No replicas = down |
| Requests | — | — | — | — | — | Baseline-dependent |
| Requests Failed | 10 | 50 | 5 | 25 | 5 min | |
| Response Time (ms) | 2000 | 5000 | 1000 | 3000 | 5 min | |
| Replica Restart Count | 5 | 20 | 2 | 10 | 5 min | Crash loop indicator |
| Network In Bytes | — | — | — | — | — | Informational |
| Network Out Bytes | — | — | — | — | — | Informational |

#### 8.2.11 Redis Cache

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit | Window | Notes |
|--------|---------------|---------------|---------------|---------------|--------|-------|
| Server Load % | 80 | 95 | 70 | 90 | 5 min | |
| CPU % | 80 | 95 | 70 | 90 | 5 min | |
| Used Memory % | 80 | 95 | 70 | 90 | 5 min | |
| Used Memory RSS (MB) | 80% of limit | 95% | 70% | 90% | 5 min | |
| Connected Clients | 80% of limit | 95% | 70% | 90% | 5 min | |
| Cache Hits | — | — | — | — | — | Informational |
| Cache Misses | — | — | — | — | — | Calculate ratio |
| Cache Miss Ratio % | 50 | 80 | 30 | 60 | 5 min | Derived metric |
| Errors | 10 | 50 | 5 | 25 | 5 min | |
| Evicted Keys | 100 | 1000 | 50 | 500 | 5 min | Memory pressure |
| Expired Keys | — | — | — | — | — | Informational |
| Total Commands Processed | — | — | — | — | — | Baseline-dependent |
| Cache Latency (microseconds) | 1000 | 5000 | 500 | 2000 | 5 min | |

---

## 9. Override Mechanism

### 9.1 Override Structure

Overrides use a nested object structure. Only specify values that differ from the profile defaults.

```hcl
module "vm_alerts" {
  source  = "git::https://github.com/yourorg/terraform-azurerm-monitor-vm.git?ref=v1.0.0"
  
  resource_id    = azurerm_virtual_machine.example.id
  resource_name  = "yourorg-batch01"
  profile        = "standard"
  action_group_ids = {
    critical = azurerm_monitor_action_group.prod_critical.id
    warning  = azurerm_monitor_action_group.prod_warning.id
  }
  
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
```

### 9.2 Resolution Hierarchy

Values are resolved in the following order:

1. Override value (if specified)
2. Profile default (based on selected profile)
3. Global fallback (hardcoded safety net in base module)

### 9.3 Overridable Settings

Each metric supports the following overrides:

| Setting | Type | Description |
|---------|------|-------------|
| enabled | bool | Enable or disable the alert |
| warning_threshold | number | Warning level threshold |
| critical_threshold | number | Critical level threshold |
| severity_warning | number | Severity for warning alerts (default: 2) |
| severity_critical | number | Severity for critical alerts (default: 1) |
| aggregation | string | Aggregation type (Average, Max, Min, Total) |
| window_minutes | number | Evaluation window in minutes |
| frequency_minutes | number | Evaluation frequency in minutes |
| evaluation_periods | number | Number of periods to evaluate |
| failing_periods | number | Number of failing periods to trigger |

---

## 10. Severity Model

| Severity | Label | Operational Meaning |
|----------|-------|---------------------|
| 1 | Error | Immediate attention required, critical threshold breached |
| 2 | Warning | Business hours attention, warning threshold breached |

Severity 0 (Critical), 3 (Informational), and 4 (Verbose) are reserved for future use.

---

## 11. Action Groups

### 11.1 Structure

Action groups follow a severity and environment matrix:

| Environment | Critical (Sev 1) | Warning (Sev 2) |
|-------------|------------------|-----------------|
| Production | `ag-prod-critical` | `ag-prod-warning` |
| Non-Production | `ag-nonprod-critical` | `ag-nonprod-warning` |

### 11.2 Naming Convention

```
ag-{environment}-{severity}
```

### 11.3 Module Input

Action groups are passed to modules as a map:

```hcl
action_group_ids = {
  critical = "/subscriptions/.../resourceGroups/.../providers/microsoft.insights/actionGroups/ag-prod-critical"
  warning  = "/subscriptions/.../resourceGroups/.../providers/microsoft.insights/actionGroups/ag-prod-warning"
}
```

### 11.4 Notification Channels

| Channel | V1 | Future |
|---------|----|----|
| Email | Yes | — |
| SMS | No | Planned |

---

## 12. Naming Conventions

### 12.1 Alert Rules

```
{resource-name}-{metric}-{level}
```

| Component | Description | Examples |
|-----------|-------------|----------|
| resource-name | Name of the monitored resource | yourorg-dc01, yourorg-psql-prod |
| metric | Short identifier for the metric | cpu, memory, storage, iops |
| level | Alert level | warn, crit |

Examples:

- `yourorg-dc01-cpu-warn`
- `yourorg-dc01-cpu-crit`
- `yourorg-psql-prod-storage-crit`

### 12.2 Repositories

```
terraform-azurerm-monitor-{resource-type}
```

---

## 13. Resource Group Placement

All alert rules are deployed to a dedicated monitoring resource group per environment.

| Environment | Resource Group |
|-------------|----------------|
| Production | `rg-monitoring-prod` |
| Non-Production | `rg-monitoring-nonprod` |

This separation enables:

- Simplified RBAC management
- Environment-specific lifecycle management
- Clean decommissioning of non-production environments

---

## 14. Tagging Strategy

Alert rules are tagged with minimal operational metadata.

| Tag | Value | Purpose |
|-----|-------|---------|
| managed-by | terraform | Identifies IaC-managed resources |
| module-version | x.y.z | Tracks deployed module version |

---

## 15. Terraform State

### 15.1 Backend Configuration

Remote state is required to enable team collaboration. Azure Storage Account is the recommended backend.

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

### 15.2 State Structure

Recommended state file organisation:

```
monitoring/prod.tfstate
monitoring/nonprod.tfstate
```

---

## 16. Documentation Standards

Each module repository must include:

| File | Purpose |
|------|---------|
| README.md | Module documentation with usage examples |
| examples/ | Working example configurations |

### 16.1 README Structure

```markdown
# terraform-azurerm-monitor-{resource}

## Overview
Brief description of the module.

## Requirements
Terraform and provider version requirements.

## Inputs
Variable documentation (auto-generated via terraform-docs).

## Outputs
Output documentation.

## Profiles
Available profiles and their characteristics.

## Metrics
List of monitored metrics with descriptions.

## Examples
Links to example configurations.

## License
License information.
```

---

## 17. CI/CD

Module testing and release pipelines are out of scope for this document. Implementation will be addressed in a future iteration.

---

## 18. Deployment Workflow

1. Identify resources to monitor.
2. Classify each resource by profile (standard or critical).
3. Ensure action groups exist and obtain their resource IDs.
4. Deploy alert modules for each resource, specifying profile and action groups.
5. Apply overrides where justified.
6. Verify alerts in Azure Portal.

---

## 19. Summary

This implementation guide provides the technical specifications required to build and deploy the Azure Monitoring Framework. The modular design, profile-based configuration, and override mechanism balance standardisation with flexibility.

**V1 Implementation Priorities:**

1. Build the base alert module.
2. Implement V1 resource modules (VM, PostgreSQL, Storage, App Service, Application Gateway).
3. Create example configurations.
4. Document each module.
5. Deploy to non-production for validation.

**V2 Implementation Priorities:**

1. Implement IaaS modules (VMSS, Managed Disks, Load Balancer, VPN Gateway, ExpressRoute, Azure Firewall).
2. Implement PaaS modules (SQL DB, SQL MI, MySQL, Cosmos DB, Function App, Key Vault, Service Bus, Event Hub, AKS, Container App, Redis Cache).
3. Validate thresholds against real workloads.
4. Refine baseline-dependent metrics based on operational experience.
