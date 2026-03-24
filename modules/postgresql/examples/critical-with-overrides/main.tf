provider "azurerm" {
  features {}
}

data "azurerm_postgresql_flexible_server" "critical" {
  name                = "prod-pgsql"
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

module "postgresql_alerts" {
  source = "../../"

  resource_id         = data.azurerm_postgresql_flexible_server.critical.id
  resource_name       = "prod-pgsql-01"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  overrides = {
    cpu = {
      warning_threshold  = 70
      critical_threshold = 85
    }
    storage = {
      warning_threshold  = 75
      critical_threshold = 90
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.postgresql_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.postgresql_alerts.resolved_thresholds
}
