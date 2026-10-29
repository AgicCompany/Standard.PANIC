# Size is bytes, so size alerts require explicit enablement.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ServiceBus/namespaces/sb-test"
  resource_name       = "sb-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "size_disabled_standard" {
  command = plan

  assert {
    condition     = !output.resolved_thresholds.size.enabled && length(azurerm_monitor_metric_alert.size_warn) == 0 && length(azurerm_monitor_metric_alert.size_crit) == 0
    error_message = "standard size alerts must be disabled by default"
  }
}

run "size_disabled_critical" {
  command = plan

  variables {
    profile = "critical"
  }

  assert {
    condition     = !output.resolved_thresholds.size.enabled && length(azurerm_monitor_metric_alert.size_warn) == 0 && length(azurerm_monitor_metric_alert.size_crit) == 0
    error_message = "critical size alerts must be disabled by default"
  }
}

run "size_raw_thresholds_standard" {
  command = plan

  variables {
    overrides = {
      size = {
        enabled            = true
        warning_threshold  = 4294967296
        critical_threshold = 4831838208
      }
    }
  }

  assert {
    condition     = output.resolved_thresholds.size.enabled && length(azurerm_monitor_metric_alert.size_warn) == 1 && length(azurerm_monitor_metric_alert.size_crit) == 1
    error_message = "explicit enablement must create both size alerts"
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.size_warn[0].criteria).metric_name == "Size" && one(azurerm_monitor_metric_alert.size_crit[0].criteria).metric_name == "Size" && one(azurerm_monitor_metric_alert.size_warn[0].criteria).threshold == 4294967296 && one(azurerm_monitor_metric_alert.size_crit[0].criteria).threshold == 4831838208
    error_message = "size alert criteria must use Size and unscaled byte thresholds"
  }
}

run "size_raw_thresholds_critical" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      size = {
        enabled            = true
        warning_threshold  = 4294967296
        critical_threshold = 4831838208
      }
    }
  }

  assert {
    condition     = output.resolved_thresholds.size.enabled && length(azurerm_monitor_metric_alert.size_warn) == 1 && length(azurerm_monitor_metric_alert.size_crit) == 1
    error_message = "explicit enablement must create both size alerts"
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.size_warn[0].criteria).metric_name == "Size" && one(azurerm_monitor_metric_alert.size_crit[0].criteria).metric_name == "Size" && one(azurerm_monitor_metric_alert.size_warn[0].criteria).threshold == 4294967296 && one(azurerm_monitor_metric_alert.size_crit[0].criteria).threshold == 4831838208
    error_message = "size alert criteria must use Size and unscaled byte thresholds"
  }
}

run "size_threshold_only_stays_disabled" {
  command = plan

  variables {
    overrides = {
      size = { warning_threshold = 4294967296 }
    }
  }

  assert {
    condition     = !output.resolved_thresholds.size.enabled && length(azurerm_monitor_metric_alert.size_warn) == 0 && length(azurerm_monitor_metric_alert.size_crit) == 0
    error_message = "a threshold-only override must not enable size alerts"
  }
}
