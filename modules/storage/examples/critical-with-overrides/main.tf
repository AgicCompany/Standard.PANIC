provider "azurerm" {
  features {}
}

data "azurerm_storage_account" "critical" {
  name                = "criticalstorageaccount"
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

module "storage_alerts" {
  source = "../../"

  resource_id         = data.azurerm_storage_account.critical.id
  resource_name       = "prod-critical-storage"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Override specific thresholds for this critical storage account
  overrides = {
    latency = {
      warning_threshold  = 100  # Stricter than default critical profile
      critical_threshold = 250
    }
    throttling = {
      warning_threshold  = 1   # Very sensitive to throttling
      critical_threshold = 10
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.storage_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.storage_alerts.resolved_thresholds
}
