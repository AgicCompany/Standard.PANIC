# terraform-azurerm-monitor-aks

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Kubernetes Service (AKS) monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Node CPU and memory monitoring
- Node disk usage tracking
- Pod readiness monitoring
- Node count alerting (cluster health)
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| Node CPU | Node CPU usage % | > 80% | > 95% | > 70% | > 90% |
| Node Memory | Node memory usage % | > 80% | > 95% | > 70% | > 90% |
| Node Disk | Node disk usage % | > 80% | > 90% | > 70% | > 85% |
| Pod Ready | Pods in ready state % | < 80% | < 50% | < 90% | < 70% |
| Node Count | Ready nodes (disabled) | < 3 | < 1 | < 5 | < 3 |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "aks_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/aks?ref=aks-v1.0.0"

  resource_id         = azurerm_kubernetes_cluster.main.id
  resource_name       = "app-aks"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Node Count Monitoring

```hcl
module "aks_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/aks?ref=aks-v1.0.0"

  resource_id         = azurerm_kubernetes_cluster.main.id
  resource_name       = "prod-aks"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    node_count = {
      enabled            = true
      warning_threshold  = 5  # Alert if fewer than 5 ready nodes
      critical_threshold = 3  # Critical if fewer than 3 ready nodes
    }
    node_cpu = {
      warning_threshold  = 60
      critical_threshold = 80
    }
  }
}
```

### High-Density Cluster Configuration

```hcl
module "aks_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/aks?ref=aks-v1.0.0"

  resource_id         = azurerm_kubernetes_cluster.main.id
  resource_name       = "highdensity-aks"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    node_memory = {
      warning_threshold  = 85
      critical_threshold = 95
    }
    pod_ready = {
      warning_threshold  = 95
      critical_threshold = 80
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_id | Resource ID of the AKS cluster to monitor | `string` | n/a | yes |
| resource_name | Display name for the alerts (used in alert naming) | `string` | n/a | yes |
| resource_group_name | Resource group where the alerts will be created | `string` | n/a | yes |
| action_group_ids | Map of action group IDs for alert notifications | `object` | n/a | yes |
| profile | Alert profile to use (standard or critical) | `string` | `"standard"` | no |
| overrides | Optional overrides for specific metrics | `object` | `{}` | no |
| enabled | Enable or disable all alerts | `bool` | `true` | no |
| tags | Additional tags to apply to all alerts | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alert_ids | Map of created alert rule IDs |
| alert_names | Map of created alert rule names |
| profile | The alert profile used |
| resolved_thresholds | Final threshold values after applying overrides |

## Notes

- **Node metrics**: These are cluster-wide aggregates. For per-node monitoring, use Container Insights.
- **Pod Ready**: Monitors the percentage of pods in ready state across the cluster.
- **Node Count**: Disabled by default. Enable and set thresholds based on your minimum cluster requirements.
- **Container Insights**: For detailed pod/container metrics, enable Container Insights on your AKS cluster.

## Prerequisites

For full metrics availability:
- Enable Azure Monitor for containers (Container Insights)
- Ensure the monitoring addon is enabled on the AKS cluster

## License

MIT
