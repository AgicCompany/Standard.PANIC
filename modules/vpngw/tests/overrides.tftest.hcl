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
      tunnel_bandwidth = { warning_threshold = 81 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.tunnel_bandwidth_warn) == 0 && length(azurerm_monitor_metric_alert.tunnel_bandwidth_crit) == 0
    error_message = "a threshold-only override must not enable tunnel_bandwidth alerts"
  }

  assert {
    condition     = output.resolved_thresholds.tunnel_bandwidth.warning_threshold == 81
    error_message = "tunnel_bandwidth warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.tunnel_bandwidth.critical_threshold == 95 && output.resolved_thresholds.tunnel_bandwidth.window_minutes == 5
    error_message = "tunnel_bandwidth fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      tunnel_bandwidth = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.tunnel_bandwidth_warn) == 0 && length(azurerm_monitor_metric_alert.tunnel_bandwidth_crit) == 0
    error_message = "enabled = false must remove the tunnel_bandwidth alerts"
  }
}

run "critical_profile_values" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      tunnel_bandwidth = { enabled = true }
    }
  }

  assert {
    condition     = output.resolved_thresholds.tunnel_bandwidth.warning_threshold == 70 && output.resolved_thresholds.tunnel_bandwidth.critical_threshold == 90
    error_message = "the critical profile must supply the tunnel_bandwidth thresholds"
  }
}
