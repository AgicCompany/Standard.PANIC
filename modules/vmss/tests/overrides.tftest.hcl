# Default alerts and override behavior for the vmss module.

mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-test"
  resource_name       = "vmss-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "defaults_create_all_alerts" {
  command = plan

  assert {
    condition     = length([for id in values(output.alert_names) : id if id != null]) == 10
    error_message = "all 10 alerts (5 metrics x warn/crit) must be created by default"
  }

  assert {
    condition = output.resolved_thresholds == {
      cpu            = { enabled = true, warning_threshold = 85, critical_threshold = 95, window_minutes = 5 }
      memory         = { enabled = true, warning_threshold = 15, critical_threshold = 10, window_minutes = 5 }
      os_disk_iops   = { enabled = true, warning_threshold = 85, critical_threshold = 95, window_minutes = 5 }
      data_disk_iops = { enabled = true, warning_threshold = 85, critical_threshold = 95, window_minutes = 5 }
      availability   = { enabled = true, warning_threshold = 1, critical_threshold = 0.5, window_minutes = 5 }
    }
    error_message = "standard profile values do not match the spec"
  }

  assert {
    condition     = azurerm_monitor_metric_alert.availability_crit[0].name == "vmss-test-availability-crit" && azurerm_monitor_metric_alert.os_disk_iops_warn[0].name == "vmss-test-osdiskiops-warn"
    error_message = "alert names must be {resource_name}-{suffix}-{warn|crit}"
  }

  assert {
    condition     = azurerm_monitor_metric_alert.availability_crit[0].description == "Critical: Scale set average VM availability (1 = all instances available) below 0.5"
    error_message = "availability description must say 'below' with no percent sign"
  }
}

run "critical_profile" {
  command = plan

  variables {
    profile = "critical"
  }

  assert {
    condition     = output.resolved_thresholds.availability.critical_threshold == 0.75 && output.resolved_thresholds.cpu.warning_threshold == 75
    error_message = "critical profile values do not match the spec"
  }
}

run "partial_override_keeps_profile_defaults" {
  command = plan

  variables {
    overrides = {
      cpu = { warning_threshold = 90 }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.cpu_warn) == 1 && length(azurerm_monitor_metric_alert.cpu_crit) == 1
    error_message = "cpu alerts must still be created when only warning_threshold is overridden"
  }

  assert {
    condition     = output.resolved_thresholds.cpu.warning_threshold == 90 && output.resolved_thresholds.cpu.critical_threshold == 95 && output.resolved_thresholds.cpu.window_minutes == 5
    error_message = "cpu fields not overridden must keep the standard profile values"
  }
}

run "override_can_disable_metric" {
  command = plan

  variables {
    overrides = {
      cpu = { enabled = false }
    }
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.cpu_warn) == 0 && length(azurerm_monitor_metric_alert.cpu_crit) == 0
    error_message = "enabled = false must remove the cpu alerts"
  }
}

run "module_disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length([for id in values(output.alert_names) : id if id != null]) == 0
    error_message = "enabled = false on the module must create no alerts"
  }
}

run "null_overrides_from_template" {
  command = plan

  variables {
    overrides = null
  }

  assert {
    condition     = length([for id in values(output.alert_names) : id if id != null]) == 10
    error_message = "overrides = null (what the template passes) must create all 10 alerts"
  }
}

run "string_overrides_from_template_map_any" {
  command = plan

  variables {
    overrides = {
      cpu    = { warning_threshold = "90" }
      memory = { enabled = "false" }
    }
  }

  assert {
    condition     = output.resolved_thresholds.cpu.warning_threshold == 90
    error_message = "string threshold from map(any) must convert to a number"
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.memory_warn) == 0 && length(azurerm_monitor_metric_alert.memory_crit) == 0
    error_message = "string \"false\" from map(any) must disable the metric"
  }
}

run "zero_threshold_override_is_kept" {
  command = plan

  variables {
    overrides = {
      availability = { critical_threshold = 0 }
    }
  }

  assert {
    condition     = output.resolved_thresholds.availability.critical_threshold == 0
    error_message = "a 0 threshold override must not fall back to the profile value"
  }
}

run "invalid_profile_rejected" {
  command = plan

  variables {
    profile = "gold"
  }

  expect_failures = [var.profile]
}
