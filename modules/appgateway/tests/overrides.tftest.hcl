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
      unhealthy_hosts = { warning_threshold = 2 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.unhealthy_hosts_warn) == 1 && length(azurerm_monitor_metric_alert.unhealthy_hosts_crit) == 1
    error_message = "unhealthy_hosts alerts must be created after a partial override"
  }

  assert {
    condition     = output.resolved_thresholds.unhealthy_hosts.warning_threshold == 2
    error_message = "unhealthy_hosts warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.unhealthy_hosts.critical_threshold == 2 && output.resolved_thresholds.unhealthy_hosts.window_minutes == 5
    error_message = "unhealthy_hosts fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      unhealthy_hosts = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.unhealthy_hosts_warn) == 0 && length(azurerm_monitor_metric_alert.unhealthy_hosts_crit) == 0
    error_message = "enabled = false must remove the unhealthy_hosts alerts"
  }
}

run "critical_profile_values" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      unhealthy_hosts = { enabled = true }
    }
  }

  assert {
    condition     = output.resolved_thresholds.unhealthy_hosts.warning_threshold == 1 && output.resolved_thresholds.unhealthy_hosts.critical_threshold == 1
    error_message = "the critical profile must supply the unhealthy_hosts thresholds"
  }
}
