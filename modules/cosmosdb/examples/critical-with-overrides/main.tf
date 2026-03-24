provider "azurerm" {
  features {}
}

data "azurerm_cosmosdb_account" "critical" {
  name                = "prod-cosmos"
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

module "cosmosdb_alerts" {
  source = "../../"

  resource_id         = data.azurerm_cosmosdb_account.critical.id
  resource_name       = "prod-cosmos-01"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  overrides = {
    ru_consumption = {
      warning_threshold  = 70
      critical_threshold = 85
    }
    server_latency = {
      warning_threshold  = 5
      critical_threshold = 10
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.cosmosdb_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.cosmosdb_alerts.resolved_thresholds
}
