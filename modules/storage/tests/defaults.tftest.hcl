# UsedCapacity is bytes, so capacity alerts require explicit enablement.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/sttest"
  resource_name       = "storage-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "capacity_disabled_standard" {
  command = plan

  assert {
    condition     = !output.resolved_thresholds.used_capacity.enabled && length(azurerm_monitor_metric_alert.used_capacity_warn) == 0 && length(azurerm_monitor_metric_alert.used_capacity_crit) == 0
    error_message = "standard capacity alerts must be disabled by default"
  }
}

run "capacity_disabled_critical" {
  command = plan

  variables {
    profile = "critical"
  }

  assert {
    condition     = !output.resolved_thresholds.used_capacity.enabled && length(azurerm_monitor_metric_alert.used_capacity_warn) == 0 && length(azurerm_monitor_metric_alert.used_capacity_crit) == 0
    error_message = "critical capacity alerts must be disabled by default"
  }
}

run "capacity_raw_thresholds_standard" {
  command = plan

  variables {
    overrides = {
      used_capacity = {
        enabled            = true
        warning_threshold  = 1099511627776
        critical_threshold = 1649267441664
      }
    }
  }

  assert {
    condition     = output.resolved_thresholds.used_capacity.enabled && length(azurerm_monitor_metric_alert.used_capacity_warn) == 1 && length(azurerm_monitor_metric_alert.used_capacity_crit) == 1
    error_message = "explicit enablement must create both capacity alerts"
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.used_capacity_warn[0].criteria).metric_name == "UsedCapacity" && one(azurerm_monitor_metric_alert.used_capacity_crit[0].criteria).metric_name == "UsedCapacity" && one(azurerm_monitor_metric_alert.used_capacity_warn[0].criteria).threshold == 1099511627776 && one(azurerm_monitor_metric_alert.used_capacity_crit[0].criteria).threshold == 1649267441664
    error_message = "capacity alert criteria must use UsedCapacity and unscaled byte thresholds"
  }
}

run "capacity_raw_thresholds_critical" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      used_capacity = {
        enabled            = true
        warning_threshold  = 1099511627776
        critical_threshold = 1649267441664
      }
    }
  }

  assert {
    condition     = output.resolved_thresholds.used_capacity.enabled && length(azurerm_monitor_metric_alert.used_capacity_warn) == 1 && length(azurerm_monitor_metric_alert.used_capacity_crit) == 1
    error_message = "explicit enablement must create both capacity alerts"
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.used_capacity_warn[0].criteria).metric_name == "UsedCapacity" && one(azurerm_monitor_metric_alert.used_capacity_crit[0].criteria).metric_name == "UsedCapacity" && one(azurerm_monitor_metric_alert.used_capacity_warn[0].criteria).threshold == 1099511627776 && one(azurerm_monitor_metric_alert.used_capacity_crit[0].criteria).threshold == 1649267441664
    error_message = "capacity alert criteria must use UsedCapacity and unscaled byte thresholds"
  }
}

run "capacity_threshold_only_stays_disabled" {
  command = plan

  variables {
    overrides = {
      used_capacity = { warning_threshold = 1099511627776 }
    }
  }

  assert {
    condition     = !output.resolved_thresholds.used_capacity.enabled && length(azurerm_monitor_metric_alert.used_capacity_warn) == 0 && length(azurerm_monitor_metric_alert.used_capacity_crit) == 0
    error_message = "a threshold-only override must not enable capacity alerts"
  }
}
