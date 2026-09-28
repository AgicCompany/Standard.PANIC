# Partial overrides must keep profile values for every field not overridden.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/sttest"
  resource_name       = "storage-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "partial_override_keeps_profile_defaults" {
  command = plan

  variables {
    overrides = {
      availability = { warning_threshold = 99.5 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.availability_warn) == 1 && length(azurerm_monitor_metric_alert.availability_crit) == 1
    error_message = "availability alerts must still be created when only warning_threshold is overridden"
  }

  assert {
    condition     = output.resolved_thresholds.availability.warning_threshold == 99.5
    error_message = "availability warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.availability.critical_threshold == 99 && output.resolved_thresholds.availability.window_minutes == 5
    error_message = "availability fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      availability = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.availability_warn) == 0 && length(azurerm_monitor_metric_alert.availability_crit) == 0
    error_message = "enabled = false must remove the availability alerts"
  }
}
