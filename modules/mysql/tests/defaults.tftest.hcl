# active_connections is a raw count, not a percentage of max_connections.
mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.DBforMySQL/flexibleServers/mysql-test"
  resource_name       = "mysql-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "defaults_standard" {
  command = plan
  assert {
    condition     = !output.resolved_thresholds.connections.enabled && length(azurerm_monitor_metric_alert.connections_warn) == 0 && length(azurerm_monitor_metric_alert.connections_crit) == 0
    error_message = "connections must be disabled by default"
  }
}

run "defaults_critical" {
  command = plan
  variables { profile = "critical" }
  assert {
    condition     = !output.resolved_thresholds.connections.enabled && length(azurerm_monitor_metric_alert.connections_warn) == 0 && length(azurerm_monitor_metric_alert.connections_crit) == 0
    error_message = "connections must be disabled by default"
  }
}

run "raw_thresholds_standard" {
  command = plan
  variables {
    overrides = { connections = { enabled = true, warning_threshold = 400, critical_threshold = 475 } }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.connections_warn[0].criteria).metric_name == "active_connections" && one(azurerm_monitor_metric_alert.connections_warn[0].criteria).threshold == 400 && one(azurerm_monitor_metric_alert.connections_crit[0].criteria).threshold == 475
    error_message = "explicit enablement must create active_connections alerts with unscaled count thresholds"
  }
}

run "raw_thresholds_critical" {
  command = plan
  variables {
    profile   = "critical"
    overrides = { connections = { enabled = true, warning_threshold = 400, critical_threshold = 475 } }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.connections_warn[0].criteria).metric_name == "active_connections" && one(azurerm_monitor_metric_alert.connections_warn[0].criteria).threshold == 400 && one(azurerm_monitor_metric_alert.connections_crit[0].criteria).threshold == 475
    error_message = "explicit enablement must create active_connections alerts with unscaled count thresholds"
  }
}

run "threshold_only_stays_disabled" {
  command = plan
  variables {
    overrides = { connections = { warning_threshold = 400 } }
  }
  assert {
    condition     = !output.resolved_thresholds.connections.enabled && length(azurerm_monitor_metric_alert.connections_warn) == 0 && length(azurerm_monitor_metric_alert.connections_crit) == 0
    error_message = "a threshold-only override must not enable connections"
  }
}
