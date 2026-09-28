provider "azurerm" {
  features {}
}

data "azurerm_virtual_machine_scale_set" "critical" {
  name                = "prod-vmss"
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

module "vmss_alerts" {
  source = "../../"

  resource_id         = data.azurerm_virtual_machine_scale_set.critical.id
  resource_name       = "prod-vmss-01"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  overrides = {
    # Batch workload: sustained high CPU is expected
    cpu = {
      warning_threshold  = 90
      critical_threshold = 98
    }
    # No data disks attached
    data_disk_iops = {
      enabled = false
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.vmss_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.vmss_alerts.resolved_thresholds
}
