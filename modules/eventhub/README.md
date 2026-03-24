# terraform-azurerm-monitor-eventhub

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Event Hubs monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Throttling detection
- Quota exceeded error monitoring
- Server error tracking
- Incoming message volume monitoring
- Capture backlog monitoring (for Event Hubs Capture)
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| Throttled Requests | Rate limiting | > 5 | > 20 | > 1 | > 10 |
| Quota Exceeded | Quota errors | > 1 | > 10 | > 1 | > 5 |
| Server Errors | 5xx errors | > 5 | > 20 | > 1 | > 10 |
| Incoming Messages | Message count (disabled) | > 100k | > 500k | > 100k | > 500k |
| Capture Backlog | Backlog count (disabled) | > 1000 | > 10000 | > 500 | > 5000 |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "eventhub_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/eventhub?ref=eventhub/v1.0.0"

  resource_id         = azurerm_eventhub_namespace.main.id
  resource_name       = "app-eventhub"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Custom Thresholds

```hcl
module "eventhub_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/eventhub?ref=eventhub/v1.0.0"

  resource_id         = azurerm_eventhub_namespace.main.id
  resource_name       = "prod-eventhub"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    throttled_requests = {
      warning_threshold  = 1
      critical_threshold = 5
    }
    quota_exceeded = {
      warning_threshold  = 1
      critical_threshold = 3
    }
  }
}
```

### With Capture Backlog Monitoring

```hcl
module "eventhub_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/eventhub?ref=eventhub/v1.0.0"

  resource_id         = azurerm_eventhub_namespace.main.id
  resource_name       = "capture-eventhub"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    capture_backlog = {
      enabled            = true
      warning_threshold  = 500
      critical_threshold = 2000
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
| resource_id | Resource ID of the Event Hubs namespace to monitor | `string` | n/a | yes |
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

- **Throttled Requests**: Indicates throughput exceeds tier limits. Consider scaling up.
- **Quota Exceeded**: Critical - indicates namespace limits reached.
- **Capture Backlog**: Only relevant if using Event Hubs Capture feature.
- **Incoming Messages**: Disabled by default. Enable for traffic pattern monitoring.

## Event Hubs Limits by Tier

| Tier | TUs/PUs | Ingress/TU | Egress/TU |
|------|---------|------------|-----------|
| Basic | 1-20 TU | 1 MB/s | 2 MB/s |
| Standard | 1-20 TU | 1 MB/s | 2 MB/s |
| Premium | 1-16 PU | ~100 MB/s/PU | ~200 MB/s/PU |
| Dedicated | 1-20 CU | ~100 MB/s/CU | ~200 MB/s/CU |

## License

MIT
