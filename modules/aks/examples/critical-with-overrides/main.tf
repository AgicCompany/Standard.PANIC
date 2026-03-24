provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "critical" {
  name                = "prod-aks"
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

module "aks_alerts" {
  source = "../../"

  resource_id         = data.azurerm_kubernetes_cluster.critical.id
  resource_name       = "prod-aks-01"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  overrides = {
    node_count = {
      enabled            = true
      warning_threshold  = 5
      critical_threshold = 3
    }
    node_cpu = {
      warning_threshold  = 60
      critical_threshold = 80
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.aks_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.aks_alerts.resolved_thresholds
}
