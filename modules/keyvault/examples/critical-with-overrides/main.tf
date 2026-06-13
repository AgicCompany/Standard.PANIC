provider "azurerm" {
  features {}
}

data "azurerm_key_vault" "critical" {
  name                = "prod-keyvault-secrets"
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

module "keyvault_alerts" {
  source = "../../"

  resource_id         = data.azurerm_key_vault.critical.id
  resource_name       = "prod-kv-secrets"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = data.azurerm_monitor_action_group.critical.id
    warning  = data.azurerm_monitor_action_group.warning.id
  }

  # Override specific thresholds for this critical key vault
  overrides = {
    availability = {
      warning_threshold  = 99.9 # Near-zero tolerance for secret store unavailability
      critical_threshold = 99
    }
    latency = {
      warning_threshold  = 500 # Stricter latency for auth-critical workloads
      critical_threshold = 1000
    }
  }

  tags = {
    environment = "production"
    criticality = "high"
  }
}

output "alert_ids" {
  value = module.keyvault_alerts.alert_ids
}

output "resolved_thresholds" {
  value = module.keyvault_alerts.resolved_thresholds
}
