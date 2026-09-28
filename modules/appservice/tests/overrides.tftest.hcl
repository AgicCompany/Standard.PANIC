# Partial overrides must keep profile values for every field not overridden.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/app-test"
  resource_name       = "appservice-test"
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
      http_5xx = { warning_threshold = 20 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.http_5xx_warn) == 1 && length(azurerm_monitor_metric_alert.http_5xx_crit) == 1
    error_message = "http_5xx alerts must still be created when only warning_threshold is overridden"
  }

  assert {
    condition     = output.resolved_thresholds.http_5xx.warning_threshold == 20
    error_message = "http_5xx warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.http_5xx.critical_threshold == 50 && output.resolved_thresholds.http_5xx.window_minutes == 5
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

run "override_can_enable_metric" {
  command = plan

  variables {
    overrides = {
      cpu = { enabled = true }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.cpu_warn) == 1 && length(azurerm_monitor_metric_alert.cpu_crit) == 1
    error_message = "enabled = true must create alerts for a metric that is off by default"
  }
}
