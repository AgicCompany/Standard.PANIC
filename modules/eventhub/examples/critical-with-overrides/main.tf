provider "azurerm" {
  features {}
}

data "azurerm_eventhub_namespace" "critical" {
  name                = "critical-eventhub-namespace"
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

module "eventhub_alerts" {
  source = "../../"

  resource_id         = data.azurerm_eventhub_namespace.critical.id
  resource_name       = "prod-eh-ingest"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Tight throttling and ingestion thresholds for production ingest namespace
  overrides = {
    throttled_requests = {
      warning_threshold  = 1
      critical_threshold = 5
    }
    incoming_messages = {
      warning_threshold  = 80
      critical_threshold = 90
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.eventhub_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.eventhub_alerts.resolved_thresholds
}
