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
      active_messages = { warning_threshold = 1001 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.active_messages_warn) == 1 && length(azurerm_monitor_metric_alert.active_messages_crit) == 1
    error_message = "active_messages alerts must be created after a partial override"
  }

  assert {
    condition     = output.resolved_thresholds.active_messages.warning_threshold == 1001
    error_message = "active_messages warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.active_messages.critical_threshold == 5000 && output.resolved_thresholds.active_messages.window_minutes == 5
    error_message = "active_messages fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      active_messages = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.active_messages_warn) == 0 && length(azurerm_monitor_metric_alert.active_messages_crit) == 0
    error_message = "enabled = false must remove the active_messages alerts"
  }
}

run "critical_profile_values" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      active_messages = { enabled = true }
    }
  }

  assert {
    condition     = output.resolved_thresholds.active_messages.warning_threshold == 500 && output.resolved_thresholds.active_messages.critical_threshold == 2000
    error_message = "the critical profile must supply the active_messages thresholds"
  }
}
