# No tunnel state metric exists; bandwidth and P2S metrics use raw units.
mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworkGateways/vpngw-test"
  resource_name       = "vpngw-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "defaults_standard" {
  command = plan
  assert {
    condition     = !output.resolved_thresholds.tunnel_status.enabled && !output.resolved_thresholds.tunnel_bandwidth.enabled && !output.resolved_thresholds.p2s_bandwidth.enabled && !output.resolved_thresholds.p2s_connection_count.enabled && length(azurerm_monitor_metric_alert.tunnel_status_crit) + length(azurerm_monitor_metric_alert.tunnel_bandwidth_warn) + length(azurerm_monitor_metric_alert.tunnel_bandwidth_crit) + length(azurerm_monitor_metric_alert.p2s_bandwidth_warn) + length(azurerm_monitor_metric_alert.p2s_bandwidth_crit) + length(azurerm_monitor_metric_alert.p2s_connection_count_warn) + length(azurerm_monitor_metric_alert.p2s_connection_count_crit) == 0
    error_message = "only tunnel_drop_count may be enabled by default"
  }
}

run "defaults_critical" {
  command = plan
  variables { profile = "critical" }
  assert {
    condition     = !output.resolved_thresholds.tunnel_status.enabled && !output.resolved_thresholds.tunnel_bandwidth.enabled && !output.resolved_thresholds.p2s_bandwidth.enabled && !output.resolved_thresholds.p2s_connection_count.enabled && length(azurerm_monitor_metric_alert.tunnel_status_crit) + length(azurerm_monitor_metric_alert.tunnel_bandwidth_warn) + length(azurerm_monitor_metric_alert.tunnel_bandwidth_crit) + length(azurerm_monitor_metric_alert.p2s_bandwidth_warn) + length(azurerm_monitor_metric_alert.p2s_bandwidth_crit) + length(azurerm_monitor_metric_alert.p2s_connection_count_warn) + length(azurerm_monitor_metric_alert.p2s_connection_count_crit) == 0
    error_message = "only tunnel_drop_count may be enabled by default"
  }
}

run "raw_thresholds_standard" {
  command = plan
  variables {
    overrides = {
      tunnel_status        = { enabled = true, critical_threshold = 1 }
      tunnel_bandwidth     = { enabled = true, warning_threshold = 1048576, critical_threshold = 2097152 }
      p2s_bandwidth        = { enabled = true, warning_threshold = 524288, critical_threshold = 1048576 }
      p2s_connection_count = { enabled = true, warning_threshold = 100, critical_threshold = 150 }
    }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.tunnel_status_crit[0].criteria).metric_name == "TunnelIngressPackets" && one(azurerm_monitor_metric_alert.tunnel_status_crit[0].criteria).aggregation == "Total" && one(azurerm_monitor_metric_alert.tunnel_status_crit[0].criteria).operator == "LessThan" && one(azurerm_monitor_metric_alert.tunnel_status_crit[0].criteria).threshold == 1
    error_message = "tunnel_status must alert on total inbound packets below 1, not bandwidth or tunnel state"
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.tunnel_bandwidth_warn[0].criteria).metric_name == "TunnelAverageBandwidth" && one(azurerm_monitor_metric_alert.tunnel_bandwidth_warn[0].criteria).threshold == 1048576 && one(azurerm_monitor_metric_alert.tunnel_bandwidth_crit[0].criteria).threshold == 2097152 && one(azurerm_monitor_metric_alert.p2s_bandwidth_warn[0].criteria).threshold == 524288 && one(azurerm_monitor_metric_alert.p2s_bandwidth_crit[0].criteria).threshold == 1048576 && one(azurerm_monitor_metric_alert.p2s_connection_count_warn[0].criteria).threshold == 100 && one(azurerm_monitor_metric_alert.p2s_connection_count_crit[0].criteria).threshold == 150
    error_message = "explicit enablement must create bandwidth and P2S alerts with unscaled Bytes/sec and count thresholds"
  }
}

run "raw_thresholds_critical" {
  command = plan
  variables {
    profile = "critical"
    overrides = {
      tunnel_status        = { enabled = true, critical_threshold = 1 }
      tunnel_bandwidth     = { enabled = true, warning_threshold = 1048576, critical_threshold = 2097152 }
      p2s_bandwidth        = { enabled = true, warning_threshold = 524288, critical_threshold = 1048576 }
      p2s_connection_count = { enabled = true, warning_threshold = 100, critical_threshold = 150 }
    }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.tunnel_status_crit[0].criteria).metric_name == "TunnelIngressPackets" && one(azurerm_monitor_metric_alert.tunnel_status_crit[0].criteria).aggregation == "Total" && one(azurerm_monitor_metric_alert.tunnel_status_crit[0].criteria).operator == "LessThan" && one(azurerm_monitor_metric_alert.tunnel_status_crit[0].criteria).threshold == 1
    error_message = "tunnel_status must alert on total inbound packets below 1, not bandwidth or tunnel state"
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.tunnel_bandwidth_warn[0].criteria).metric_name == "TunnelAverageBandwidth" && one(azurerm_monitor_metric_alert.tunnel_bandwidth_warn[0].criteria).threshold == 1048576 && one(azurerm_monitor_metric_alert.tunnel_bandwidth_crit[0].criteria).threshold == 2097152 && one(azurerm_monitor_metric_alert.p2s_bandwidth_warn[0].criteria).threshold == 524288 && one(azurerm_monitor_metric_alert.p2s_bandwidth_crit[0].criteria).threshold == 1048576 && one(azurerm_monitor_metric_alert.p2s_connection_count_warn[0].criteria).threshold == 100 && one(azurerm_monitor_metric_alert.p2s_connection_count_crit[0].criteria).threshold == 150
    error_message = "explicit enablement must create bandwidth and P2S alerts with unscaled Bytes/sec and count thresholds"
  }
}

run "threshold_only_stays_disabled" {
  command = plan
  variables {
    overrides = {
      tunnel_status    = { critical_threshold = 1 }
      tunnel_bandwidth = { warning_threshold = 1048576 }
    }
  }
  assert {
    condition     = !output.resolved_thresholds.tunnel_status.enabled && !output.resolved_thresholds.tunnel_bandwidth.enabled && length(azurerm_monitor_metric_alert.tunnel_status_crit) + length(azurerm_monitor_metric_alert.tunnel_bandwidth_warn) + length(azurerm_monitor_metric_alert.tunnel_bandwidth_crit) == 0
    error_message = "threshold-only overrides must not enable tunnel status or bandwidth alerts"
  }
}

run "tunnel_drop_uses_valid_metric_name" {
  command = plan
  assert {
    condition     = one(azurerm_monitor_metric_alert.tunnel_drop_count_warn[0].criteria).metric_name == "TunnelEgressPacketDropCount"
    error_message = "tunnel_drop_count must use a metric listed on Microsoft Learn (TunnelDropCount does not exist)"
  }
}
