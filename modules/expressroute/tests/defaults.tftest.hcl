# Link bandwidth utilization is Percent with Maximum aggregation, no dimension filters.
mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/expressRouteCircuits/expressroute-test"
  resource_name       = "expressroute-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "defaults_standard" {
  command = plan
  assert {
    condition     = output.resolved_thresholds.bits_in.enabled && output.resolved_thresholds.bits_out.enabled && alltrue([for alert in concat(azurerm_monitor_metric_alert.bits_in_warn, azurerm_monitor_metric_alert.bits_in_crit) : one(alert.criteria).metric_name == "IngressBandwidthUtilization" && one(alert.criteria).aggregation == "Maximum" && length(one(alert.criteria).dimension) == 0]) && alltrue([for alert in concat(azurerm_monitor_metric_alert.bits_out_warn, azurerm_monitor_metric_alert.bits_out_crit) : one(alert.criteria).metric_name == "EgressBandwidthUtilization" && one(alert.criteria).aggregation == "Maximum" && length(one(alert.criteria).dimension) == 0])
    error_message = "both bandwidth metrics must use utilization metrics with Maximum aggregation and no dimension filters"
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.bits_in_warn[0].criteria).threshold == 80 && one(azurerm_monitor_metric_alert.bits_in_crit[0].criteria).threshold == 95 && one(azurerm_monitor_metric_alert.bits_out_warn[0].criteria).threshold == 80 && one(azurerm_monitor_metric_alert.bits_out_crit[0].criteria).threshold == 95
    error_message = "standard bandwidth alerts must retain 80/95 percent thresholds"
  }
}

run "defaults_critical" {
  command = plan
  variables { profile = "critical" }
  assert {
    condition     = output.resolved_thresholds.bits_in.enabled && output.resolved_thresholds.bits_out.enabled && alltrue([for alert in concat(azurerm_monitor_metric_alert.bits_in_warn, azurerm_monitor_metric_alert.bits_in_crit) : one(alert.criteria).metric_name == "IngressBandwidthUtilization" && one(alert.criteria).aggregation == "Maximum" && length(one(alert.criteria).dimension) == 0]) && alltrue([for alert in concat(azurerm_monitor_metric_alert.bits_out_warn, azurerm_monitor_metric_alert.bits_out_crit) : one(alert.criteria).metric_name == "EgressBandwidthUtilization" && one(alert.criteria).aggregation == "Maximum" && length(one(alert.criteria).dimension) == 0])
    error_message = "both bandwidth metrics must use utilization metrics with Maximum aggregation and no dimension filters"
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.bits_in_warn[0].criteria).threshold == 70 && one(azurerm_monitor_metric_alert.bits_in_crit[0].criteria).threshold == 90 && one(azurerm_monitor_metric_alert.bits_out_warn[0].criteria).threshold == 70 && one(azurerm_monitor_metric_alert.bits_out_crit[0].criteria).threshold == 90
    error_message = "critical bandwidth alerts must retain 70/90 percent thresholds"
  }
}

run "dropped_metrics_use_rest_api_names" {
  command = plan
  assert {
    condition     = one(azurerm_monitor_metric_alert.dropped_packets_in_warn[0].criteria).metric_name == "QosDropBitsInPerSecond" && one(azurerm_monitor_metric_alert.dropped_packets_out_warn[0].criteria).metric_name == "QosDropBitsOutPerSecond"
    error_message = "dropped-bits alerts must use the REST API metric names listed on Microsoft Learn"
  }
}
