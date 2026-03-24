# terraform-azurerm-monitor-servicebus

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Service Bus monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Active message queue depth monitoring
- Dead-letter queue monitoring
- Throttling detection
- Server error tracking
- Namespace size monitoring
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| Active Messages | Queue depth | > 1000 | > 5000 | > 500 | > 2000 |
| Dead-lettered | Failed messages | > 10 | > 100 | > 1 | > 50 |
| Throttled Requests | Rate limiting | > 5 | > 20 | > 1 | > 10 |
| Server Errors | 5xx errors | > 5 | > 20 | > 1 | > 10 |
| Size | Namespace size | > 80% | > 90% | > 70% | > 85% |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "servicebus_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/servicebus?ref=servicebus/v1.0.0"

  resource_id         = azurerm_servicebus_namespace.main.id
  resource_name       = "app-servicebus"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Custom Thresholds

```hcl
module "servicebus_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/servicebus?ref=servicebus/v1.0.0"

  resource_id         = azurerm_servicebus_namespace.main.id
  resource_name       = "prod-servicebus"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    active_messages = {
      warning_threshold  = 100
      critical_threshold = 500
    }
    deadlettered_messages = {
      warning_threshold  = 1
      critical_threshold = 10
    }
    size = {
      # 5 GB namespace (Premium)
      warning_threshold  = 4294967296  # 4 GB (80%)
      critical_threshold = 4831838208  # 4.5 GB (90%)
    }
  }
}
```

### High-Throughput Configuration

```hcl
module "servicebus_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/servicebus?ref=servicebus/v1.0.0"

  resource_id         = azurerm_servicebus_namespace.main.id
  resource_name       = "highvol-servicebus"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    active_messages = {
      warning_threshold  = 10000
      critical_threshold = 50000
    }
    throttled_requests = {
      warning_threshold  = 50
      critical_threshold = 200
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
| resource_id | Resource ID of the Service Bus namespace to monitor | `string` | n/a | yes |
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

- **Active Messages**: High counts indicate slow consumers or processing issues.
- **Dead-lettered Messages**: Any dead letters require investigation - indicates processing failures.
- **Throttling**: Occurs when throughput exceeds tier limits. Consider upgrading tier or adding partitions.
- **Size**: Override with actual byte values based on your namespace quota.

## Service Bus Limits by Tier

| Tier | Max Size | Message Units | Partitions |
|------|----------|---------------|------------|
| Basic | 1 GB | N/A | N/A |
| Standard | 1-5 GB | 0-20 | No |
| Premium | 1-80 GB | 1-16 | Yes |

## License

MIT
