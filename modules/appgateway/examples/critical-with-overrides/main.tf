provider "azurerm" {
  features {}
}

data "azurerm_application_gateway" "critical" {
  name                = "prod-agw-frontend"
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

module "appgateway_alerts" {
  source = "../../"

  resource_id         = data.azurerm_application_gateway.critical.id
  resource_name       = "prod-agw-frontend"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Low tolerance for unhealthy backends and elevated error response rates
  overrides = {
    unhealthy_host_count = {
      warning_threshold  = 1
      critical_threshold = 3
    }
    response_status = {
      warning_threshold  = 10
      critical_threshold = 50
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.appgateway_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.appgateway_alerts.resolved_thresholds
}
