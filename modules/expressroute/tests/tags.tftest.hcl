mock_provider "azurerm" {}

variables {
  resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Test/resources/res-test"
  resource_name       = "res-test"
  resource_group_name = "rg-test"
  action_group_ids = {
    critical = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-critical"
    warning  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/microsoft.insights/actionGroups/ag-warning"
  }
  tags = {
    owner = "team-a"
  }
}

run "alert_tags" {
  command = plan

  assert {
    condition     = azurerm_monitor_metric_alert.bgp_availability_warn[0].tags == tomap({ owner = "team-a", managed-by = "terraform", profile = "standard", severity = "warning" })
    error_message = "warning alert must carry the user tags plus managed-by, profile and severity"
  }

  assert {
    condition     = azurerm_monitor_metric_alert.bgp_availability_crit[0].tags == tomap({ owner = "team-a", managed-by = "terraform", profile = "standard", severity = "critical" })
    error_message = "critical alert must carry the user tags plus managed-by, profile and severity"
  }
}
