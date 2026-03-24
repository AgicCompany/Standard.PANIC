provider "azurerm" {
  features {}
}

data "azurerm_firewall" "critical" {
  name                = "critical-firewall"
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

module "firewall_alerts" {
  source = "../../"

  resource_id         = data.azurerm_firewall.critical.id
  resource_name       = "prod-fw-hub"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Tight health state thresholds for hub firewall — any degradation is significant
  overrides = {
    health_state = {
      warning_threshold  = 95
      critical_threshold = 90
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.firewall_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.firewall_alerts.resolved_thresholds
}
