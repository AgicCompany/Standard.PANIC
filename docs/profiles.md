# Profiles

PANIC uses a profile-based system to provide consistent thresholds across resource types.

## Available Profiles

| Profile | Intent | Use Case |
|---------|--------|----------|
| **Standard** | Balanced thresholds, moderate severities | Default for most resources |
| **Critical** | Tighter thresholds, higher severities | Business-critical resources |

## Profile Selection

Select a profile at deployment time:

```hcl
module "db_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-postgresql.git?ref=v1.0.0"

  resource_id    = azurerm_postgresql_flexible_server.main.id
  resource_name  = "prod-database"
  profile        = "critical"  # or "standard"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

## Threshold Patterns

### Standard Profile

- Warning thresholds at ~80-85%
- Critical thresholds at ~90-95%
- Suitable for non-production or standard workloads

### Critical Profile

- Warning thresholds at ~70-75%
- Critical thresholds at ~85-90%
- Earlier alerting for proactive response

## Example: Virtual Machine Thresholds

| Metric | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|---------------|---------------|---------------|---------------|
| CPU % | 85 | 95 | 75 | 90 |
| Memory % | 15 (available) | 10 | 20 | 15 |
| OS Disk IOPS % | 85 | 95 | 75 | 90 |
| Data Disk IOPS % | 85 | 95 | 75 | 90 |

## Severity Model

| Severity | Label | Action |
|----------|-------|--------|
| 1 | Error | Immediate attention required |
| 2 | Warning | Business hours attention |

## Alert Defaults

| Setting | Default | Notes |
|---------|---------|-------|
| Aggregation | Average | Override to Max for burst metrics |
| Frequency | 1 minute | How often the rule evaluates |
| Window | 5 minutes | Default evaluation window |
| Sev 1 Evaluation | 1 of 1 | Immediate for critical |
| Sev 2 Evaluation | 3 of 5 | Sustained for warnings |
| Auto-resolve | true | Alert closes when condition clears |

## Customizing with Overrides

When a profile doesn't fit, use overrides for specific metrics:

```hcl
module "batch_vm_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vm.git?ref=v1.0.0"

  resource_id    = azurerm_virtual_machine.batch.id
  resource_name  = "batch-processor"
  profile        = "standard"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  # Batch workloads tolerate higher CPU usage
  overrides = {
    cpu = {
      warning_threshold  = 95
      critical_threshold = 99
    }
  }
}
```

See [Architecture](architecture.md) for the full override mechanism.
