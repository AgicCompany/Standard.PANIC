resource "azurerm_monitor_metric_alert" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = var.description
  severity            = var.severity
  enabled             = var.enabled
  auto_mitigate       = var.auto_mitigate
  frequency           = var.frequency
  window_size         = var.window_size

  criteria {
    metric_namespace = var.metric_namespace
    metric_name      = var.metric_name
    aggregation      = var.aggregation
    operator         = var.operator
    threshold        = var.threshold

    dynamic "dimension" {
      for_each = var.dimensions
      content {
        name     = dimension.value.name
        operator = dimension.value.operator
        values   = dimension.value.values
      }
    }
  }

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}
