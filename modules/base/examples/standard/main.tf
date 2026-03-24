provider "azurerm" {
  features {}
}

module "cpu_warning_alert" {
  source = "../../"

  name                = "example-vm-cpu-warn"
  resource_group_name = "rg-monitoring-dev"
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-example/providers/Microsoft.Compute/virtualMachines/example-vm"
  metric_namespace    = "Microsoft.Compute/virtualMachines"
  metric_name         = "Percentage CPU"
  aggregation         = "Average"
  operator            = "GreaterThan"
  threshold           = 85
  severity            = 2
  window_size         = "PT5M"
  frequency           = "PT1M"
  action_group_id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitoring-dev/providers/microsoft.insights/actionGroups/ag-dev-warning"

  tags = {
    managed-by     = "terraform"
    module-version = "1.0.0"
  }
}
