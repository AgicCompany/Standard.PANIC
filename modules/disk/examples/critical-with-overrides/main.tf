provider "azurerm" {
  features {}
}

data "azurerm_managed_disk" "critical" {
  name                = "critical-managed-disk"
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

module "disk_alerts" {
  source = "../../"

  resource_id         = data.azurerm_managed_disk.critical.id
  resource_name       = "prod-disk-data"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Stricter IOPS thresholds for production data disk
  overrides = {
    iops_consumed = {
      warning_threshold  = 80
      critical_threshold = 95
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.disk_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.disk_alerts.resolved_thresholds
}
