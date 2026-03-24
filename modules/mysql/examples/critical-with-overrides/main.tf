provider "azurerm" {
  features {}
}

data "azurerm_mysql_flexible_server" "critical" {
  name                = "prod-mysql-app"
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

module "mysql_alerts" {
  source = "../../"

  resource_id         = data.azurerm_mysql_flexible_server.critical.id
  resource_name       = "prod-mysql-app"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Override specific thresholds for this production database
  overrides = {
    cpu = {
      warning_threshold  = 70  # Tighter CPU headroom for query-heavy workloads
      critical_threshold = 85
    }
    storage = {
      warning_threshold  = 75  # Catch storage growth before it becomes an incident
      critical_threshold = 90
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.mysql_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.mysql_alerts.resolved_thresholds
}
