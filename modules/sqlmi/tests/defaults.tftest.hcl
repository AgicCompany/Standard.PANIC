# IO metrics are raw counts and bytes, not percentages of SKU limits.
mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Sql/managedInstances/sqlmi-test"
  resource_name       = "sqlmi-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "defaults_standard" {
  command = plan
  assert {
    condition     = !output.resolved_thresholds.io_requests.enabled && !output.resolved_thresholds.io_bytes.enabled && length(azurerm_monitor_metric_alert.io_requests_warn) + length(azurerm_monitor_metric_alert.io_requests_crit) + length(azurerm_monitor_metric_alert.io_bytes_warn) + length(azurerm_monitor_metric_alert.io_bytes_crit) == 0
    error_message = "IO alerts must be disabled by default"
  }
}

run "defaults_critical" {
  command = plan
  variables { profile = "critical" }
  assert {
    condition     = !output.resolved_thresholds.io_requests.enabled && !output.resolved_thresholds.io_bytes.enabled && length(azurerm_monitor_metric_alert.io_requests_warn) + length(azurerm_monitor_metric_alert.io_requests_crit) + length(azurerm_monitor_metric_alert.io_bytes_warn) + length(azurerm_monitor_metric_alert.io_bytes_crit) == 0
    error_message = "IO alerts must be disabled by default"
  }
}

run "raw_thresholds_standard" {
  command = plan
  variables {
    overrides = {
      io_requests = { enabled = true, warning_threshold = 4000, critical_threshold = 5000 }
      io_bytes    = { enabled = true, warning_threshold = 1048576, critical_threshold = 2097152 }
    }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.io_requests_warn[0].criteria).metric_name == "io_requests" && one(azurerm_monitor_metric_alert.io_requests_warn[0].criteria).threshold == 4000 && one(azurerm_monitor_metric_alert.io_requests_crit[0].criteria).threshold == 5000 && one(azurerm_monitor_metric_alert.io_bytes_warn[0].criteria).metric_name == "io_bytes_read" && one(azurerm_monitor_metric_alert.io_bytes_warn[0].criteria).threshold == 1048576 && one(azurerm_monitor_metric_alert.io_bytes_crit[0].criteria).threshold == 2097152
    error_message = "explicit enablement must create IO alerts with unscaled count and byte thresholds"
  }
}

run "raw_thresholds_critical" {
  command = plan
  variables {
    profile = "critical"
    overrides = {
      io_requests = { enabled = true, warning_threshold = 4000, critical_threshold = 5000 }
      io_bytes    = { enabled = true, warning_threshold = 1048576, critical_threshold = 2097152 }
    }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.io_requests_warn[0].criteria).metric_name == "io_requests" && one(azurerm_monitor_metric_alert.io_requests_warn[0].criteria).threshold == 4000 && one(azurerm_monitor_metric_alert.io_requests_crit[0].criteria).threshold == 5000 && one(azurerm_monitor_metric_alert.io_bytes_warn[0].criteria).metric_name == "io_bytes_read" && one(azurerm_monitor_metric_alert.io_bytes_warn[0].criteria).threshold == 1048576 && one(azurerm_monitor_metric_alert.io_bytes_crit[0].criteria).threshold == 2097152
    error_message = "explicit enablement must create IO alerts with unscaled count and byte thresholds"
  }
}

run "threshold_only_stays_disabled" {
  command = plan
  variables {
    overrides = {
      io_requests = { warning_threshold = 4000 }
      io_bytes    = { warning_threshold = 1048576 }
    }
  }
  assert {
    condition     = !output.resolved_thresholds.io_requests.enabled && !output.resolved_thresholds.io_bytes.enabled && length(azurerm_monitor_metric_alert.io_requests_warn) + length(azurerm_monitor_metric_alert.io_requests_crit) + length(azurerm_monitor_metric_alert.io_bytes_warn) + length(azurerm_monitor_metric_alert.io_bytes_crit) == 0
    error_message = "threshold-only overrides must not enable IO alerts"
  }
}
