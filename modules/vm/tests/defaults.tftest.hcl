# disk_free is a guest metric: off by default, and the namespace/name follow os_type.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/virtualMachines/vm-test"
  resource_name       = "vm-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "disk_free_off_by_default" {
  command = plan

  assert {
    condition     = length(azurerm_monitor_metric_alert.disk_free_warn) + length(azurerm_monitor_metric_alert.disk_free_crit) == 0
    error_message = "disk_free must be disabled by default"
  }
}

run "disk_free_linux_default" {
  command = plan

  variables {
    overrides = { disk_free = { enabled = true } }
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.disk_free_warn[0].criteria).metric_namespace == "Azure.VM.Linux.GuestMetrics" && one(azurerm_monitor_metric_alert.disk_free_warn[0].criteria).metric_name == "disk/free_percent" && one(azurerm_monitor_metric_alert.disk_free_crit[0].criteria).metric_name == "disk/free_percent"
    error_message = "linux is the default os_type and must use the Linux guest metric"
  }
}

run "disk_free_windows" {
  command = plan

  variables {
    os_type   = "windows"
    overrides = { disk_free = { enabled = true, critical_threshold = 5 } }
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.disk_free_warn[0].criteria).metric_namespace == "Azure.VM.Windows.GuestMetrics" && one(azurerm_monitor_metric_alert.disk_free_warn[0].criteria).metric_name == "\\LogicalDisk(_Total)\\% Free Space"
    error_message = "windows must use the Windows guest metric"
  }

  assert {
    condition     = one(azurerm_monitor_metric_alert.disk_free_crit[0].criteria).threshold == 5 && one(azurerm_monitor_metric_alert.disk_free_warn[0].criteria).threshold == 15
    error_message = "threshold overrides must pass through and keep the profile warning value"
  }
}

run "os_type_validation" {
  command = plan

  variables {
    os_type = "macos"
  }

  expect_failures = [var.os_type]
}
