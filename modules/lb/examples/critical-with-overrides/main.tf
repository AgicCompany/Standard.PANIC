provider "azurerm" {
  features {}
}

data "azurerm_lb" "critical" {
  name                = "prod-lb-frontend"
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

module "lb_alerts" {
  source = "../../"

  resource_id         = data.azurerm_lb.critical.id
  resource_name       = "prod-lb-frontend"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Override specific thresholds for this production-facing load balancer
  overrides = {
    health_probe_status = {
      critical_threshold = 90 # Percent of healthy backends
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.lb_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.lb_alerts.resolved_thresholds
}
