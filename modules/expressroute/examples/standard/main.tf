provider "azurerm" {
  features {}
}

data "azurerm_express_route_circuit" "example" {
  name                = "example-expressroute-circuit"
  resource_group_name = "rg-example"
}

data "azurerm_monitor_action_group" "critical" {
  name                = "ag-dev-critical"
  resource_group_name = "rg-monitoring-dev"
}

data "azurerm_monitor_action_group" "warning" {
  name                = "ag-dev-warning"
  resource_group_name = "rg-monitoring-dev"
}

module "expressroute_alerts" {
  source = "../../"

  resource_id         = data.azurerm_express_route_circuit.example.id
  resource_name       = "dev-er-01"
  resource_group_name = "rg-monitoring-dev"
  profile             = "standard"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  tags = {
    environment = "development"
  }
}

output "alert_ids" {
  value = module.expressroute_alerts.alert_ids
}
