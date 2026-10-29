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
      health_state = { warning_threshold = 100 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.health_state_warn) == 1 && length(azurerm_monitor_metric_alert.health_state_crit) == 1
    error_message = "health_state alerts must be created after a partial override"
  }

  assert {
    condition     = output.resolved_thresholds.health_state.warning_threshold == 100
    error_message = "health_state warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.health_state.critical_threshold == 95 && output.resolved_thresholds.health_state.window_minutes == 1
    error_message = "health_state fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      health_state = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.health_state_warn) == 0 && length(azurerm_monitor_metric_alert.health_state_crit) == 0
    error_message = "enabled = false must remove the health_state alerts"
  }
}

run "critical_profile_values" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      health_state = { enabled = true }
    }
  }

  assert {
    condition     = output.resolved_thresholds.health_state.warning_threshold == 99.5 && output.resolved_thresholds.health_state.critical_threshold == 99
    error_message = "the critical profile must supply the health_state thresholds"
  }
}
