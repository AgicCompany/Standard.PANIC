# terraform-azurerm-monitor-redis

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Cache for Redis monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Server load monitoring
- Memory usage tracking
- Connected clients monitoring
- Cache miss rate alerting
- Key eviction tracking
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| Server Load | CPU load % | > 70% | > 90% | > 60% | > 80% |
| Memory | Used memory % | > 70% | > 90% | > 60% | > 80% |
| Connected Clients | Client count | > 80% | > 95% | > 70% | > 90% |
| Cache Miss Rate | Miss % (disabled) | > 50% | > 80% | > 30% | > 60% |
| Evicted Keys | Eviction count | > 100 | > 1000 | > 10 | > 100 |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "redis_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/redis?ref=redis-v1.0.0"

  resource_id         = azurerm_redis_cache.main.id
  resource_name       = "app-redis"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Custom Thresholds

```hcl
module "redis_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/redis?ref=redis-v1.0.0"

  resource_id         = azurerm_redis_cache.main.id
  resource_name       = "prod-redis"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    server_load = {
      warning_threshold  = 50
      critical_threshold = 70
    }
    connected_clients = {
      # Premium P1 has 7,500 max clients
      warning_threshold  = 5250  # 70%
      critical_threshold = 6750  # 90%
    }
  }
}
```

### With Cache Miss Monitoring

```hcl
module "redis_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/redis?ref=redis-v1.0.0"

  resource_id         = azurerm_redis_cache.main.id
  resource_name       = "session-redis"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    cache_miss_rate = {
      enabled            = true
      warning_threshold  = 20
      critical_threshold = 40
    }
    evicted_keys = {
      warning_threshold  = 10
      critical_threshold = 50
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
| resource_id | Resource ID of the Redis cache to monitor | `string` | n/a | yes |
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

- **Server Load**: High load indicates CPU saturation. Consider scaling up or optimizing queries.
- **Memory**: When memory fills, Redis evicts keys (if configured) or rejects writes.
- **Connected Clients**: Override with actual counts based on your tier's max connections.
- **Cache Miss Rate**: Disabled by default. Expected rate varies by workload.
- **Evicted Keys**: Any evictions indicate memory pressure.

## Redis Tier Limits

| Tier | Max Clients | Memory |
|------|-------------|--------|
| Basic C0 | 256 | 250 MB |
| Basic C1 | 1,000 | 1 GB |
| Standard C2 | 2,000 | 2.5 GB |
| Premium P1 | 7,500 | 6 GB |
| Premium P2 | 15,000 | 13 GB |
| Premium P3 | 30,000 | 26 GB |
| Premium P4 | 40,000 | 53 GB |

## License

MIT
