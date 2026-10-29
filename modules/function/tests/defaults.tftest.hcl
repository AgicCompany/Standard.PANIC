# MemoryWorkingSet is bytes, so memory alerts require explicit enablement.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Web/sites/function-test"
  resource_name       = "function-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "memory_disabled_standard" {
  command = plan

  assert {
    condition     = !output.resolved_thresholds.memory.enabled && length(azurerm_monitor_metric_alert.memory_warn) == 0 && length(azurerm_monitor_metric_alert.memory_crit) == 0
    error_message = "standard memory alerts must be disabled by default"
  }
}

run "memory_disabled_critical" {
  command = plan

  variables {
    profile = "critical"
  }

  assert {
    condition     = !output.resolved_thresholds.memory.enabled && length(azurerm_monitor_metric_alert.memory_warn) == 0 && length(azurerm_monitor_metric_alert.memory_crit) == 0
    error_message = "critical memory alerts must be disabled by default"
  }
}

run "memory_raw_thresholds_standard" {
  command = plan

  variables {
    overrides = {
      memory = {
        enabled            = true
        warning_threshold  = 2147483648
        critical_threshold = 3221225472
      }
    }
  }

  assert {
    condition     = output.resolved_thresholds.memory.enabled && length(azurerm_monitor_metric_alert.memory_warn) == 1 && length(azurerm_monitor_metric_alert.memory_crit) == 1
    error_message = "explicit enablement must create both memory alerts"
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.memory_warn[0].criteria).metric_name == "MemoryWorkingSet" && one(azurerm_monitor_metric_alert.memory_crit[0].criteria).metric_name == "MemoryWorkingSet" && one(azurerm_monitor_metric_alert.memory_warn[0].criteria).threshold == 2147483648 && one(azurerm_monitor_metric_alert.memory_crit[0].criteria).threshold == 3221225472
    error_message = "memory alert criteria must use MemoryWorkingSet and unscaled byte thresholds"
  }
}

run "memory_raw_thresholds_critical" {
  command = plan

  variables {
    profile = "critical"
    overrides = {
      memory = {
        enabled            = true
        warning_threshold  = 2147483648
        critical_threshold = 3221225472
      }
    }
  }

  assert {
    condition     = output.resolved_thresholds.memory.enabled && length(azurerm_monitor_metric_alert.memory_warn) == 1 && length(azurerm_monitor_metric_alert.memory_crit) == 1
    error_message = "explicit enablement must create both memory alerts"
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.memory_warn[0].criteria).metric_name == "MemoryWorkingSet" && one(azurerm_monitor_metric_alert.memory_crit[0].criteria).metric_name == "MemoryWorkingSet" && one(azurerm_monitor_metric_alert.memory_warn[0].criteria).threshold == 2147483648 && one(azurerm_monitor_metric_alert.memory_crit[0].criteria).threshold == 3221225472
    error_message = "memory alert criteria must use MemoryWorkingSet and unscaled byte thresholds"
  }
}

run "memory_threshold_only_stays_disabled" {
  command = plan

  variables {
    overrides = {
      memory = { warning_threshold = 2147483648 }
    }
  }

  assert {
    condition     = !output.resolved_thresholds.memory.enabled && length(azurerm_monitor_metric_alert.memory_warn) == 0 && length(azurerm_monitor_metric_alert.memory_crit) == 0
    error_message = "a threshold-only override must not enable memory alerts"
  }
}
