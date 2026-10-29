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
      server_load = { warning_threshold = 71 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.server_load_warn) == 1 && length(azurerm_monitor_metric_alert.server_load_crit) == 1
    error_message = "server_load alerts must be created after a partial override"
  }

  assert {
    condition     = output.resolved_thresholds.server_load.warning_threshold == 71
    error_message = "server_load warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.server_load.critical_threshold == 90 && output.resolved_thresholds.server_load.window_minutes == 5
    error_message = "server_load fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      server_load = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.server_load_warn) == 0 && length(azurerm_monitor_metric_alert.server_load_crit) == 0
    error_message = "enabled = false must remove the server_load alerts"
  }
}

run "critical_profile_values" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      server_load = { enabled = true }
    }
  }

  assert {
    condition     = output.resolved_thresholds.server_load.warning_threshold == 60 && output.resolved_thresholds.server_load.critical_threshold == 80
    error_message = "the critical profile must supply the server_load thresholds"
  }
}
