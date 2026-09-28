# Overrides for different metrics on different resources of one type must be
# accepted, and a resource without overrides may sit next to one with them.

mock_provider "azurerm" {}

variables {
  subscription_id     = "00000000-0000-0000-0000-000000000000"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
}

run "mixed_override_shapes" {
  command = plan

  variables {
    enable_vm_alerts = true
    vms = {
      vm-cpu = {
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/virtualMachines/vm-cpu"
        overrides   = { cpu = { warning_threshold = 90 } }
      }
      vm-mem = {
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/virtualMachines/vm-mem"
        overrides   = { memory = { enabled = false } }
      }
      vm-plain = {
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/virtualMachines/vm-plain"
      }
    }
  }

  assert {
    condition     = length(module.vm_alerts) == 3
    error_message = "all three VMs must get an alert module instance"
  }

  assert {
    condition     = module.vm_alerts["vm-cpu"].resolved_thresholds.cpu.warning_threshold == 90
    error_message = "vm-cpu must keep its cpu warning override"
  }
}
