provider "azurerm" {
  features {}
}

data "azurerm_container_app" "critical" {
  name                = "prod-containerapp-api"
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

module "containerapp_alerts" {
  source = "../../"

  resource_id         = data.azurerm_container_app.critical.id
  resource_name       = "prod-capp-api"
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
    replica_count = {
      enabled = true
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.containerapp_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.containerapp_alerts.resolved_thresholds
}
