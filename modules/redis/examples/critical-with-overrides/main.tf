provider "azurerm" {
  features {}
}

data "azurerm_redis_cache" "critical" {
  name                = "prod-redis-session"
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

module "redis_alerts" {
  source = "../../"

  resource_id         = data.azurerm_redis_cache.critical.id
  resource_name       = "prod-redis-session"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Override specific thresholds for this session-store cache
  overrides = {
    server_load = {
      warning_threshold  = 70 # Prevent eviction storms before they cascade
      critical_threshold = 85
    }
    cache_miss_rate = {
      enabled = true # Explicitly enable; high miss rates tank app performance
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.redis_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.redis_alerts.resolved_thresholds
}
