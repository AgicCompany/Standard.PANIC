provider "azurerm" {
  features {}
}

data "azurerm_mssql_managed_instance" "critical" {
  name                = "prod-sqlmi-erp"
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

module "sqlmi_alerts" {
  source = "../../"

  resource_id         = data.azurerm_mssql_managed_instance.critical.id
  resource_name       = "prod-sqlmi-erp"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Tighter CPU and stricter storage headroom for ERP workload
  overrides = {
    cpu = {
      warning_threshold  = 70
      critical_threshold = 85
    }
    storage = {
      warning_threshold  = 75
      critical_threshold = 90
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.sqlmi_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.sqlmi_alerts.resolved_thresholds
}
