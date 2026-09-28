provider "azurerm" {
  features {}
}

data "azurerm_virtual_machine_scale_set" "example" {
  name                = "example-vmss"
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

module "vmss_alerts" {
  source = "../../"

  resource_id         = data.azurerm_virtual_machine_scale_set.example.id
  resource_name       = "dev-vmss-01"
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
  value = module.vmss_alerts.alert_ids
}
