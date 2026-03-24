provider "azurerm" {
  features {}
}

data "azurerm_linux_web_app" "production" {
  name                = "prod-api"
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

module "appservice_alerts" {
  source = "../../"

  resource_id         = data.azurerm_linux_web_app.production.id
  resource_name       = "prod-api"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Stricter thresholds for production API
  overrides = {
    response_time = {
      warning_threshold  = 500
      critical_threshold = 1000
    }
    http_5xx = {
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
  value = module.appservice_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.appservice_alerts.resolved_thresholds
}
