provider "azurerm" {
  features {}
}

data "azurerm_linux_function_app" "critical" {
  name                = "critical-function-app"
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

module "function_alerts" {
  source = "../../"

  resource_id         = data.azurerm_linux_function_app.critical.id
  resource_name       = "prod-func-processor"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Zero-tolerance error rate and tight response time for production processor
  overrides = {
    http_5xx = {
      warning_threshold  = 1
      critical_threshold = 5
    }
    response_time = {
      warning_threshold  = 500
      critical_threshold = 1000
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.function_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.function_alerts.resolved_thresholds
}
