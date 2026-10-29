# Microsoft.Compute/disks only exposes raw rate metrics, so no alert is on by default.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/disks/disk-test"
  resource_name       = "disk-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "no_alerts_by_default_standard" {
  command = plan

  assert {
    condition     = length(azurerm_monitor_metric_alert.iops_consumed_warn) + length(azurerm_monitor_metric_alert.iops_consumed_crit) + length(azurerm_monitor_metric_alert.bandwidth_consumed_warn) + length(azurerm_monitor_metric_alert.bandwidth_consumed_crit) + length(azurerm_monitor_metric_alert.queue_depth_warn) + length(azurerm_monitor_metric_alert.queue_depth_crit) + length(azurerm_monitor_metric_alert.burst_bps_credits_warn) + length(azurerm_monitor_metric_alert.burst_bps_credits_crit) + length(azurerm_monitor_metric_alert.burst_io_credits_warn) + length(azurerm_monitor_metric_alert.burst_io_credits_crit) == 0
    error_message = "the standard profile must not create any disk alert by default"
  }
}

run "no_alerts_by_default_critical" {
  command = plan

  variables {
    profile = "critical"
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.iops_consumed_warn) + length(azurerm_monitor_metric_alert.iops_consumed_crit) + length(azurerm_monitor_metric_alert.bandwidth_consumed_warn) + length(azurerm_monitor_metric_alert.bandwidth_consumed_crit) + length(azurerm_monitor_metric_alert.queue_depth_warn) + length(azurerm_monitor_metric_alert.queue_depth_crit) + length(azurerm_monitor_metric_alert.burst_bps_credits_warn) + length(azurerm_monitor_metric_alert.burst_bps_credits_crit) + length(azurerm_monitor_metric_alert.burst_io_credits_warn) + length(azurerm_monitor_metric_alert.burst_io_credits_crit) == 0
    error_message = "the critical profile must not create any disk alert by default"
  }
}

run "iops_enabled_with_raw_thresholds" {
  command = plan

  variables {
    overrides = {
      iops_consumed = {
        enabled            = true
        warning_threshold  = 4000
        critical_threshold = 4750
      }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.iops_consumed_warn) == 1 && length(azurerm_monitor_metric_alert.iops_consumed_crit) == 1
    error_message = "enabled = true must create the iops_consumed alerts"
  }

  assert {
    condition     = output.resolved_thresholds.iops_consumed.warning_threshold == 4000 && output.resolved_thresholds.iops_consumed.critical_threshold == 4750
    error_message = "iops_consumed raw thresholds not applied"
  }
}

run "queue_depth_does_not_duplicate_another_metric" {
  command = plan

  variables {
    overrides = {
      iops_consumed = { enabled = true }
      queue_depth   = { enabled = true }
    }
  }

  assert {
    condition     = azurerm_monitor_metric_alert.queue_depth_warn[0].criteria[0].metric_name != azurerm_monitor_metric_alert.iops_consumed_warn[0].criteria[0].metric_name
    error_message = "queue_depth must not use the same metric as iops_consumed"
  }
}
