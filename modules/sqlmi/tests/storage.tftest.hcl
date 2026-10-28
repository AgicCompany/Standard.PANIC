# storage_space_used_mb is a raw MB metric, so its alert must be opt-in.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Sql/managedInstances/sqlmi-test"
  resource_name       = "sqlmi-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "storage_disabled_by_default_standard" {
  command = plan

  assert {
    condition     = length(azurerm_monitor_metric_alert.storage_warn) == 0 && length(azurerm_monitor_metric_alert.storage_crit) == 0
    error_message = "storage alerts must be disabled by default in the standard profile"
  }
}

run "storage_disabled_by_default_critical" {
  command = plan

  variables {
    profile = "critical"
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.storage_warn) == 0 && length(azurerm_monitor_metric_alert.storage_crit) == 0
    error_message = "storage alerts must be disabled by default in the critical profile"
  }
}

run "storage_enabled_with_mb_thresholds" {
  command = plan

  variables {
    overrides = {
      storage = {
        enabled            = true
        warning_threshold  = 209715
        critical_threshold = 235929
      }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.storage_warn) == 1 && length(azurerm_monitor_metric_alert.storage_crit) == 1
    error_message = "enabled = true must create the storage alerts"
  }

  assert {
    condition     = output.resolved_thresholds.storage.warning_threshold == 209715 && output.resolved_thresholds.storage.critical_threshold == 235929
    error_message = "storage MB thresholds not applied"
  }
}
