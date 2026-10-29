# connectedclients is a raw count, not a percentage of the client limit.
mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Cache/redis/redis-test"
  resource_name       = "redis-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "defaults_standard" {
  command = plan
  assert {
    condition     = !output.resolved_thresholds.connected_clients.enabled && length(azurerm_monitor_metric_alert.connected_clients_warn) == 0 && length(azurerm_monitor_metric_alert.connected_clients_crit) == 0
    error_message = "connected_clients must be disabled by default"
  }
}

run "defaults_critical" {
  command = plan
  variables { profile = "critical" }
  assert {
    condition     = !output.resolved_thresholds.connected_clients.enabled && length(azurerm_monitor_metric_alert.connected_clients_warn) == 0 && length(azurerm_monitor_metric_alert.connected_clients_crit) == 0
    error_message = "connected_clients must be disabled by default"
  }
}

run "raw_thresholds_standard" {
  command = plan
  variables {
    overrides = { connected_clients = { enabled = true, warning_threshold = 5250, critical_threshold = 6750 } }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.connected_clients_warn[0].criteria).metric_name == "connectedclients" && one(azurerm_monitor_metric_alert.connected_clients_warn[0].criteria).threshold == 5250 && one(azurerm_monitor_metric_alert.connected_clients_crit[0].criteria).threshold == 6750
    error_message = "explicit enablement must create connectedclients alerts with unscaled count thresholds"
  }
}

run "raw_thresholds_critical" {
  command = plan
  variables {
    profile   = "critical"
    overrides = { connected_clients = { enabled = true, warning_threshold = 5250, critical_threshold = 6750 } }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.connected_clients_warn[0].criteria).metric_name == "connectedclients" && one(azurerm_monitor_metric_alert.connected_clients_warn[0].criteria).threshold == 5250 && one(azurerm_monitor_metric_alert.connected_clients_crit[0].criteria).threshold == 6750
    error_message = "explicit enablement must create connectedclients alerts with unscaled count thresholds"
  }
}

run "threshold_only_stays_disabled" {
  command = plan
  variables {
    overrides = { connected_clients = { warning_threshold = 5250 } }
  }
  assert {
    condition     = !output.resolved_thresholds.connected_clients.enabled && length(azurerm_monitor_metric_alert.connected_clients_warn) == 0 && length(azurerm_monitor_metric_alert.connected_clients_crit) == 0
    error_message = "a threshold-only override must not enable connected_clients"
  }
}
