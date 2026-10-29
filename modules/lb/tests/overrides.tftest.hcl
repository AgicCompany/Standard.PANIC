# Partial overrides must keep profile values for every field not overridden.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Test/resources/res-test"
  resource_name       = "res-test"
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
      data_path_availability = { warning_threshold = 100.9 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.data_path_availability_warn) == 1 && length(azurerm_monitor_metric_alert.data_path_availability_crit) == 1
    error_message = "data_path_availability alerts must be created after a partial override"
  }

  assert {
    condition     = output.resolved_thresholds.data_path_availability.warning_threshold == 100.9
    error_message = "data_path_availability warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.data_path_availability.critical_threshold == 99 && output.resolved_thresholds.data_path_availability.window_minutes == 1
    error_message = "data_path_availability fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      data_path_availability = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.data_path_availability_warn) == 0 && length(azurerm_monitor_metric_alert.data_path_availability_crit) == 0
    error_message = "enabled = false must remove the data_path_availability alerts"
  }
}

run "critical_profile_values" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      data_path_availability = { enabled = true }
    }
  }

  assert {
    condition     = output.resolved_thresholds.data_path_availability.warning_threshold == 99.95 && output.resolved_thresholds.data_path_availability.critical_threshold == 99.5
    error_message = "the critical profile must supply the data_path_availability thresholds"
  }
}
