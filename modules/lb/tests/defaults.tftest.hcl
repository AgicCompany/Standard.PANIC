# Health uses percent; SNAT metrics require explicit raw count thresholds.
mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/loadBalancers/lb-test"
  resource_name       = "lb-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "defaults_standard" {
  command = plan
  assert {
    condition     = !output.resolved_thresholds.snat_connection_count.enabled && !output.resolved_thresholds.used_snat_ports.enabled && length(azurerm_monitor_metric_alert.snat_connection_count_warn) + length(azurerm_monitor_metric_alert.snat_connection_count_crit) + length(azurerm_monitor_metric_alert.used_snat_ports_warn) + length(azurerm_monitor_metric_alert.used_snat_ports_crit) == 0
    error_message = "SNAT alerts must be disabled by default"
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.health_probe_status_crit[0].criteria).threshold == 100
    error_message = "the default planned health probe threshold must be 100 percent"
  }
}

run "defaults_critical" {
  command = plan
  variables { profile = "critical" }
  assert {
    condition     = !output.resolved_thresholds.snat_connection_count.enabled && !output.resolved_thresholds.used_snat_ports.enabled && length(azurerm_monitor_metric_alert.snat_connection_count_warn) + length(azurerm_monitor_metric_alert.snat_connection_count_crit) + length(azurerm_monitor_metric_alert.used_snat_ports_warn) + length(azurerm_monitor_metric_alert.used_snat_ports_crit) == 0
    error_message = "SNAT alerts must be disabled by default"
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.health_probe_status_crit[0].criteria).threshold == 100
    error_message = "the default planned health probe threshold must be 100 percent"
  }
}

run "raw_thresholds_standard" {
  command = plan
  variables {
    overrides = {
      health_probe_status   = { critical_threshold = 50 }
      snat_connection_count = { enabled = true, warning_threshold = 1000, critical_threshold = 2000 }
      used_snat_ports       = { enabled = true, warning_threshold = 4000, critical_threshold = 5000 }
    }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.health_probe_status_crit[0].criteria).threshold == 50
    error_message = "a health probe override of 50 must be passed through unscaled"
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.snat_connection_count_warn[0].criteria).metric_name == "SnatConnectionCount" && one(azurerm_monitor_metric_alert.snat_connection_count_warn[0].criteria).threshold == 1000 && one(azurerm_monitor_metric_alert.snat_connection_count_crit[0].criteria).threshold == 2000 && one(azurerm_monitor_metric_alert.used_snat_ports_warn[0].criteria).metric_name == "UsedSnatPorts" && one(azurerm_monitor_metric_alert.used_snat_ports_warn[0].criteria).threshold == 4000 && one(azurerm_monitor_metric_alert.used_snat_ports_crit[0].criteria).threshold == 5000
    error_message = "explicit enablement must create SNAT alerts with unscaled count thresholds"
  }
}

run "raw_thresholds_critical" {
  command = plan
  variables {
    profile = "critical"
    overrides = {
      health_probe_status   = { critical_threshold = 50 }
      snat_connection_count = { enabled = true, warning_threshold = 1000, critical_threshold = 2000 }
      used_snat_ports       = { enabled = true, warning_threshold = 4000, critical_threshold = 5000 }
    }
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.health_probe_status_crit[0].criteria).threshold == 50
    error_message = "a health probe override of 50 must be passed through unscaled"
  }
  assert {
    condition     = one(azurerm_monitor_metric_alert.snat_connection_count_warn[0].criteria).metric_name == "SnatConnectionCount" && one(azurerm_monitor_metric_alert.snat_connection_count_warn[0].criteria).threshold == 1000 && one(azurerm_monitor_metric_alert.snat_connection_count_crit[0].criteria).threshold == 2000 && one(azurerm_monitor_metric_alert.used_snat_ports_warn[0].criteria).metric_name == "UsedSnatPorts" && one(azurerm_monitor_metric_alert.used_snat_ports_warn[0].criteria).threshold == 4000 && one(azurerm_monitor_metric_alert.used_snat_ports_crit[0].criteria).threshold == 5000
    error_message = "explicit enablement must create SNAT alerts with unscaled count thresholds"
  }
}

run "threshold_only_stays_disabled" {
  command = plan
  variables {
    overrides = {
      snat_connection_count = { warning_threshold = 1000 }
      used_snat_ports       = { warning_threshold = 4000 }
    }
  }
  assert {
    condition     = !output.resolved_thresholds.snat_connection_count.enabled && !output.resolved_thresholds.used_snat_ports.enabled && length(azurerm_monitor_metric_alert.snat_connection_count_warn) + length(azurerm_monitor_metric_alert.snat_connection_count_crit) + length(azurerm_monitor_metric_alert.used_snat_ports_warn) + length(azurerm_monitor_metric_alert.used_snat_ports_crit) == 0
    error_message = "threshold-only overrides must not enable SNAT alerts"
  }
}
