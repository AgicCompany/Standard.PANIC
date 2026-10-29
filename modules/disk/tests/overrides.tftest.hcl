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
      iops_consumed = { enabled = true, warning_threshold = 86 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.iops_consumed_warn) == 1 && length(azurerm_monitor_metric_alert.iops_consumed_crit) == 1
    error_message = "iops_consumed alerts must be created after a partial override"
  }

  assert {
    condition     = output.resolved_thresholds.iops_consumed.warning_threshold == 86
    error_message = "iops_consumed warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.iops_consumed.critical_threshold == 95 && output.resolved_thresholds.iops_consumed.window_minutes == 5
    error_message = "iops_consumed fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      iops_consumed = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.iops_consumed_warn) == 0 && length(azurerm_monitor_metric_alert.iops_consumed_crit) == 0
    error_message = "enabled = false must remove the iops_consumed alerts"
  }
}

run "critical_profile_values" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      iops_consumed = { enabled = true }
    }
  }

  assert {
    condition     = output.resolved_thresholds.iops_consumed.warning_threshold == 75 && output.resolved_thresholds.iops_consumed.critical_threshold == 90
    error_message = "the critical profile must supply the iops_consumed thresholds"
  }
}
