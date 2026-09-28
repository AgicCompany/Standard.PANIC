# Partial overrides must keep profile values for every field not overridden.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.DBforPostgreSQL/flexibleServers/psql-test"
  resource_name       = "postgresql-test"
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
      cpu = { warning_threshold = 90 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.cpu_warn) == 1 && length(azurerm_monitor_metric_alert.cpu_crit) == 1
    error_message = "cpu alerts must still be created when only warning_threshold is overridden"
  }

  assert {
    condition     = output.resolved_thresholds.cpu.warning_threshold == 90
    error_message = "cpu warning_threshold override not applied"
  }

  assert {
    condition     = output.resolved_thresholds.cpu.critical_threshold == 95 && output.resolved_thresholds.cpu.window_minutes == 5
    error_message = "cpu fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      cpu = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.cpu_warn) == 0 && length(azurerm_monitor_metric_alert.cpu_crit) == 0
    error_message = "enabled = false must remove the cpu alerts"
  }
}

run "override_can_enable_metric" {
  command = plan

  variables {
    overrides = {
      replication_lag = { enabled = true }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.replication_lag_warn) == 1 && length(azurerm_monitor_metric_alert.replication_lag_crit) == 1
    error_message = "enabled = true must create alerts for a metric that is off by default"
  }
}
