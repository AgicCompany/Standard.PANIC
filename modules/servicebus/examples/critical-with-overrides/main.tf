provider "azurerm" {
  features {}
}

data "azurerm_servicebus_namespace" "critical" {
  name                = "prod-sb-orders"
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

module "servicebus_alerts" {
  source = "../../"

  resource_id         = data.azurerm_servicebus_namespace.critical.id
  resource_name       = "prod-sb-orders"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Override specific thresholds for this order-processing namespace
  overrides = {
    active_messages = {
      warning_threshold  = 500 # Queue depth indicating consumer lag
      critical_threshold = 1000
    }
    dead_letter_messages = {
      warning_threshold  = 10 # Any DLQ growth on orders is a business problem
      critical_threshold = 50
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.servicebus_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.servicebus_alerts.resolved_thresholds
}
