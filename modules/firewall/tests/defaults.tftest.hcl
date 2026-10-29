# Throughput needs raw bits/sec thresholds; latency uses FirewallLatencyPng.
mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/azureFirewalls/firewall-test"
  resource_name       = "firewall-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "defaults_standard" {
  command = plan
  assert {
    condition     = !output.resolved_thresholds.throughput.enabled && length(azurerm_monitor_metric_alert.throughput_warn) == 0 && length(azurerm_monitor_metric_alert.throughput_crit) == 0
    error_message = "throughput must be disabled by default"
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.latency_warn[0].criteria).metric_name == "FirewallLatencyPng" && one(azurerm_monitor_metric_alert.latency_crit[0].criteria).metric_name == "FirewallLatencyPng" && one(azurerm_monitor_metric_alert.latency_warn[0].criteria).aggregation == "Average"
    error_message = "latency alerts must use FirewallLatencyPng with Average aggregation"
  }
}

run "defaults_critical" {
  command = plan
  variables { profile = "critical" }
  assert {
    condition     = !output.resolved_thresholds.throughput.enabled && length(azurerm_monitor_metric_alert.throughput_warn) == 0 && length(azurerm_monitor_metric_alert.throughput_crit) == 0
    error_message = "throughput must be disabled by default"
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.latency_warn[0].criteria).metric_name == "FirewallLatencyPng" && one(azurerm_monitor_metric_alert.latency_crit[0].criteria).metric_name == "FirewallLatencyPng" && one(azurerm_monitor_metric_alert.latency_crit[0].criteria).aggregation == "Average"
    error_message = "latency alerts must use FirewallLatencyPng with Average aggregation"
  }
}

run "raw_thresholds_standard" {
  command = plan
  variables {
    overrides = { throughput = { enabled = true, warning_threshold = 1000000000, critical_threshold = 2000000000 } }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.throughput_warn[0].criteria).metric_name == "Throughput" && one(azurerm_monitor_metric_alert.throughput_warn[0].criteria).threshold == 1000000000 && one(azurerm_monitor_metric_alert.throughput_crit[0].criteria).threshold == 2000000000
    error_message = "explicit enablement must create Throughput alerts with unscaled bits/sec thresholds"
  }
}

run "raw_thresholds_critical" {
  command = plan
  variables {
    profile   = "critical"
    overrides = { throughput = { enabled = true, warning_threshold = 1000000000, critical_threshold = 2000000000 } }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.throughput_warn[0].criteria).metric_name == "Throughput" && one(azurerm_monitor_metric_alert.throughput_warn[0].criteria).threshold == 1000000000 && one(azurerm_monitor_metric_alert.throughput_crit[0].criteria).threshold == 2000000000
    error_message = "explicit enablement must create Throughput alerts with unscaled bits/sec thresholds"
  }
}

run "threshold_only_stays_disabled" {
  command = plan
  variables {
    overrides = { throughput = { warning_threshold = 1000000000 } }
  }
  assert {
    condition     = !output.resolved_thresholds.throughput.enabled && length(azurerm_monitor_metric_alert.throughput_warn) == 0 && length(azurerm_monitor_metric_alert.throughput_crit) == 0
    error_message = "a threshold-only override must not enable throughput"
  }
}
