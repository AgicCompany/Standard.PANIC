provider "azurerm" {
  features {}
}

data "azurerm_express_route_circuit" "critical" {
  name                = "critical-expressroute-circuit"
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

module "expressroute_alerts" {
  source = "../../"

  resource_id         = data.azurerm_express_route_circuit.critical.id
  resource_name       = "prod-er-primary"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Stricter BGP availability thresholds for primary production circuit
  overrides = {
    bgp_availability = {
      warning_threshold  = 99.9
      critical_threshold = 99
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.expressroute_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.expressroute_alerts.resolved_thresholds
}
