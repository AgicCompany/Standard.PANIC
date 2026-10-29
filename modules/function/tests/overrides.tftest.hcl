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
      http_5xx = { warning_threshold = 6 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.http_5xx_warn) == 1 && length(azurerm_monitor_metric_alert.http_5xx_crit) == 1
    error_message = "http_5xx alerts must be created after a partial override"
  }

  assert {
    condition     = output.resolved_thresholds.http_5xx.warning_threshold == 6
    error_message = "http_5xx warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.http_5xx.critical_threshold == 20 && output.resolved_thresholds.http_5xx.window_minutes == 5
    error_message = "http_5xx fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      http_5xx = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.http_5xx_warn) == 0 && length(azurerm_monitor_metric_alert.http_5xx_crit) == 0
    error_message = "enabled = false must remove the http_5xx alerts"
  }
}

run "critical_profile_values" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      http_5xx = { enabled = true }
    }
  }

  assert {
    condition     = output.resolved_thresholds.http_5xx.warning_threshold == 1 && output.resolved_thresholds.http_5xx.critical_threshold == 10
    error_message = "the critical profile must supply the http_5xx thresholds"
  }
}
