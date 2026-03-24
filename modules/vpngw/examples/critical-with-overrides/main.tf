provider "azurerm" {
  features {}
}

data "azurerm_virtual_network_gateway" "critical" {
  name                = "prod-vpngw-hub"
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

module "vpngw_alerts" {
  source = "../../"

  resource_id         = data.azurerm_virtual_network_gateway.critical.id
  resource_name       = "prod-vpngw-hub"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Sensitive tunnel status thresholds — any tunnel drop is an immediate concern
  overrides = {
    tunnel_status = {
      warning_threshold  = 1
      critical_threshold = 0
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.vpngw_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.vpngw_alerts.resolved_thresholds
}
