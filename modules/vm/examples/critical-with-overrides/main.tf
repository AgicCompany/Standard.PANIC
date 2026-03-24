provider "azurerm" {
  features {}
}

data "azurerm_linux_virtual_machine" "critical" {
  name                = "prod-db-vm"
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

module "vm_alerts" {
  source = "../../"

  resource_id         = data.azurerm_linux_virtual_machine.critical.id
  resource_name       = "prod-db-01"
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
    memory = {
      enabled = true
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.vm_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.vm_alerts.resolved_thresholds
}
