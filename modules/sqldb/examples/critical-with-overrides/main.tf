provider "azurerm" {
  features {}
}

data "azurerm_mssql_database" "critical" {
  name                = "prod-sqldb-app"
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

module "sqldb_alerts" {
  source = "../../"

  resource_id         = data.azurerm_mssql_database.critical.id
  resource_name       = "prod-sqldb-app"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Tighter CPU thresholds and zero-tolerance deadlock sensitivity for production
  overrides = {
    cpu = {
      warning_threshold  = 70
      critical_threshold = 85
    }
    deadlocks = {
      warning_threshold  = 1
      critical_threshold = 5
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.sqldb_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.sqldb_alerts.resolved_thresholds
}
