# terraform-azurerm-monitor-containerapp

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Container Apps monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- CPU and memory usage monitoring
- Container restart tracking
- Replica count alerting
- Request volume monitoring
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| CPU | CPU usage (nanocores) | > 70% | > 90% | > 60% | > 80% |
| Memory | Memory working set | > 70% | > 90% | > 60% | > 80% |
| Restarts | Container restarts | > 3 | > 10 | > 1 | > 5 |
| Replicas | Replica count (disabled) | < 2 | < 1 | < 3 | < 2 |
| Requests | Total requests (disabled) | > 10k | > 50k | > 10k | > 50k |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "containerapp_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/containerapp?ref=containerapp-v1.0.0"

  resource_id         = azurerm_container_app.main.id
  resource_name       = "app-containerapp"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Replica Monitoring

```hcl
module "containerapp_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/containerapp?ref=containerapp-v1.0.0"

  resource_id         = azurerm_container_app.main.id
  resource_name       = "prod-containerapp"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    replicas = {
      enabled            = true
      warning_threshold  = 3  # Alert if fewer than 3 replicas
      critical_threshold = 2  # Critical if fewer than 2 replicas
    }
    cpu = {
      # 0.5 vCPU = 500,000,000 nanocores
      warning_threshold  = 350000000  # 70% of 0.5 vCPU
      critical_threshold = 450000000  # 90% of 0.5 vCPU
    }
  }
}
```

### With Memory Limits

```hcl
module "containerapp_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/containerapp?ref=containerapp-v1.0.0"

  resource_id         = azurerm_container_app.main.id
  resource_name       = "memory-intensive-app"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    memory = {
      # 1Gi = 1073741824 bytes
      warning_threshold  = 751619276   # 70% of 1Gi
      critical_threshold = 966367641   # 90% of 1Gi
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
| resource_id | Resource ID of the Container App to monitor | `string` | n/a | yes |
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

- **CPU thresholds**: Default profile values are percentages. Override with nanocores based on your container's CPU allocation.
- **Memory thresholds**: Override with actual byte values based on your container's memory limits.
- **Restarts**: Frequent restarts indicate application issues (crashes, OOM, health check failures).
- **Replicas**: Disabled by default. Enable based on your minimum replica requirements.

## Resource Calculations

| Resource | Unit | 50% | 70% | 90% |
|----------|------|-----|-----|-----|
| 0.25 vCPU | nanocores | 125M | 175M | 225M |
| 0.5 vCPU | nanocores | 250M | 350M | 450M |
| 1 vCPU | nanocores | 500M | 700M | 900M |
| 0.5 Gi | bytes | 268M | 375M | 483M |
| 1 Gi | bytes | 537M | 751M | 966M |
| 2 Gi | bytes | 1073M | 1503M | 1932M |

## License

MIT
