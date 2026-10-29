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
      node_cpu = { warning_threshold = 81 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.node_cpu_warn) == 1 && length(azurerm_monitor_metric_alert.node_cpu_crit) == 1
    error_message = "node_cpu alerts must be created after a partial override"
  }

  assert {
    condition     = output.resolved_thresholds.node_cpu.warning_threshold == 81
    error_message = "node_cpu warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.node_cpu.critical_threshold == 95 && output.resolved_thresholds.node_cpu.window_minutes == 5
    error_message = "node_cpu fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      node_cpu = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.node_cpu_warn) == 0 && length(azurerm_monitor_metric_alert.node_cpu_crit) == 0
    error_message = "enabled = false must remove the node_cpu alerts"
  }
}

run "critical_profile_values" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      node_cpu = { enabled = true }
    }
  }

  assert {
    condition     = output.resolved_thresholds.node_cpu.warning_threshold == 70 && output.resolved_thresholds.node_cpu.critical_threshold == 90
    error_message = "the critical profile must supply the node_cpu thresholds"
  }
}
