# terraform-azurerm-monitor-keyvault

## Part of PANIC Framework

This module is part of the [PANIC Azure Monitoring Framework](https://github.com/AgicCompany/Standard.PANIC). See the main repository for:
- Complete documentation
- Profile system overview
- Implementation guides
- Full list of available modules

Terraform module for Azure Key Vault monitoring alerts using the PANIC framework.

## Features

- Profile-based alerting (standard/critical)
- Override mechanism for metric-specific customization
- Availability monitoring
- API latency tracking
- Vault saturation monitoring
- API hits tracking for anomaly detection
- Automatic severity-based action group routing

## Monitored Metrics

| Metric | Description | Standard Warn | Standard Crit | Critical Warn | Critical Crit |
|--------|-------------|---------------|---------------|---------------|---------------|
| Availability | Request availability % | < 99% | < 95% | < 99.9% | < 99% |
| Latency | API latency (ms) | > 500ms | > 1000ms | > 200ms | > 500ms |
| Saturation | Vault capacity % | > 70% | > 90% | > 60% | > 80% |
| API Hits | Request count (disabled) | > 10000 | > 50000 | > 10000 | > 50000 |

## Usage

### Basic Usage (Standard Profile)

```hcl
module "keyvault_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/keyvault?ref=keyvault/v1.0.0"

  resource_id         = azurerm_key_vault.main.id
  resource_name       = "app-keyvault"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

### Critical Profile with Custom Thresholds

```hcl
module "keyvault_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/keyvault?ref=keyvault/v1.0.0"

  resource_id         = azurerm_key_vault.main.id
  resource_name       = "prod-keyvault"
  resource_group_name = azurerm_resource_group.monitoring.name
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    latency = {
      warning_threshold  = 100
      critical_threshold = 250
    }
    saturation = {
      warning_threshold  = 50
      critical_threshold = 70
    }
  }
}
```

### Enable API Hits Monitoring

```hcl
module "keyvault_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/keyvault?ref=keyvault/v1.0.0"

  resource_id         = azurerm_key_vault.main.id
  resource_name       = "shared-keyvault"
  resource_group_name = azurerm_resource_group.monitoring.name

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }

  overrides = {
    api_hits = {
      enabled            = true
      warning_threshold  = 5000
      critical_threshold = 10000
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
| resource_id | Resource ID of the Key Vault to monitor | `string` | n/a | yes |
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

- **Availability**: Measures the percentage of successful requests to the vault.
- **Latency**: High latency can indicate throttling or network issues.
- **Saturation**: Measures vault capacity usage. High saturation may require cleanup or a new vault.
- **API Hits**: Useful for detecting abnormal access patterns or potential security incidents.

## Key Vault Limits

| Limit | Standard | Premium |
|-------|----------|---------|
| Transactions/10s | 2000 | 2000 |
| Keys per vault | Unlimited | Unlimited |
| Secrets per vault | Unlimited | Unlimited |
| Vault size | Unlimited | Unlimited |

Note: While there's no hard limit on items, high item counts can increase latency.

## License

MIT
