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
| CPU | CPU percentage of limit (preview) | > 70% | > 90% | > 60% | > 80% |
| Memory | Memory percentage of limit (preview) | > 70% | > 90% | > 60% | > 80% |
| Restarts | Container restarts | > 3 | > 10 | > 1 | > 5 |
| Replicas | Replica count (disabled) | < 2 | < 1 | < 3 | < 2 |
| Requests | Total requests (disabled) | > 10k | > 50k | > 10k | > 50k |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "containerapp_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/containerapp?ref=containerapp/v1.0.0"

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
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/containerapp?ref=containerapp/v1.0.0"

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
      # Percentage of the configured CPU limit
      warning_threshold  = 70
      critical_threshold = 90
    }
  }
}
```

### With Memory Limits

```hcl
module "containerapp_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/containerapp?ref=containerapp/v1.0.0"

  resource_id         = azurerm_container_app.main.id
  resource_name       = "memory-intensive-app"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    memory = {
      # Percentage of the configured memory limit
      warning_threshold  = 75
      critical_threshold = 95
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| azurerm | >= 4.0, < 6.0 |

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

- **CPU and memory thresholds**: `CpuPercentage` and `MemoryPercentage` are preview metrics, measured as percentages of the configured limits with `Average` aggregation. Use percentage thresholds, not nanocores or bytes. See [supported metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-app-containerapps-metrics).
- **Restarts**: Frequent restarts indicate application issues (crashes, OOM, health check failures).
- **Replicas**: Disabled by default. Enable based on your minimum replica requirements.

## Migration (next major release, unreleased)

CPU changes from `UsageNanoCores` to `CpuPercentage`; memory changes from `WorkingSetBytes` to `MemoryPercentage`. Both remain enabled, with standard thresholds of 70/90 and critical thresholds of 60/80. Convert any existing nanocore or byte overrides to percentages of the configured limit before upgrading. For example, 350,000,000 nanocores on a 0.5 vCPU limit becomes `70`, not `350000000`. If you cannot use preview metrics, disable `cpu` and `memory` via overrides.

The percentage examples above describe the unreleased change. Their source pins still reference the existing release; update the pins to the new major tag once it is published, then review `terraform plan`.

## License

MIT
