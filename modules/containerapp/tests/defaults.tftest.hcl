# CPU and memory use percentage-of-limit metrics, not raw nanocores or bytes.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.App/containerApps/app-test"
  resource_name       = "app-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "percentage_defaults_standard" {
  command = plan

  assert {
    condition     = output.resolved_thresholds.cpu.enabled && output.resolved_thresholds.memory.enabled && length(azurerm_monitor_metric_alert.cpu_warn) == 1 && length(azurerm_monitor_metric_alert.cpu_crit) == 1 && length(azurerm_monitor_metric_alert.memory_warn) == 1 && length(azurerm_monitor_metric_alert.memory_crit) == 1
    error_message = "CPU and memory alerts must be enabled in the standard profile"
  }

  assert {
    condition = alltrue([
      for alert in concat(azurerm_monitor_metric_alert.cpu_warn, azurerm_monitor_metric_alert.cpu_crit) :
      one(alert.criteria).metric_name == "CpuPercentage" && one(alert.criteria).aggregation == "Average"
      ]) && alltrue([
      for alert in concat(azurerm_monitor_metric_alert.memory_warn, azurerm_monitor_metric_alert.memory_crit) :
      one(alert.criteria).metric_name == "MemoryPercentage" && one(alert.criteria).aggregation == "Average"
    ])
    error_message = "CPU and memory must use the percentage metrics with Average aggregation"
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.cpu_warn[0].criteria).threshold == 70 && one(azurerm_monitor_metric_alert.cpu_crit[0].criteria).threshold == 90 && one(azurerm_monitor_metric_alert.memory_warn[0].criteria).threshold == 70 && one(azurerm_monitor_metric_alert.memory_crit[0].criteria).threshold == 90
    error_message = "standard CPU and memory thresholds must remain 70/90 percent"
  }
}

run "percentage_defaults_critical" {
  command = plan

  variables {
    profile = "critical"
  }

  assert {
    condition     = output.resolved_thresholds.cpu.enabled && output.resolved_thresholds.memory.enabled && length(azurerm_monitor_metric_alert.cpu_warn) == 1 && length(azurerm_monitor_metric_alert.cpu_crit) == 1 && length(azurerm_monitor_metric_alert.memory_warn) == 1 && length(azurerm_monitor_metric_alert.memory_crit) == 1
    error_message = "CPU and memory alerts must be enabled in the critical profile"
  }

  assert {
    condition = alltrue([
      for alert in concat(azurerm_monitor_metric_alert.cpu_warn, azurerm_monitor_metric_alert.cpu_crit) :
      one(alert.criteria).metric_name == "CpuPercentage" && one(alert.criteria).aggregation == "Average"
      ]) && alltrue([
      for alert in concat(azurerm_monitor_metric_alert.memory_warn, azurerm_monitor_metric_alert.memory_crit) :
      one(alert.criteria).metric_name == "MemoryPercentage" && one(alert.criteria).aggregation == "Average"
    ])
    error_message = "CPU and memory must use the percentage metrics with Average aggregation"
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.cpu_warn[0].criteria).threshold == 60 && one(azurerm_monitor_metric_alert.cpu_crit[0].criteria).threshold == 80 && one(azurerm_monitor_metric_alert.memory_warn[0].criteria).threshold == 60 && one(azurerm_monitor_metric_alert.memory_crit[0].criteria).threshold == 80
    error_message = "critical CPU and memory thresholds must remain 60/80 percent"
  }
}
