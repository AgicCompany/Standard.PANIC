# HTTP 5xx Error Alerts
resource "azurerm_monitor_metric_alert" "http_5xx_warn" {
  count = var.enabled && local.resolved.http_5xx.enabled ? 1 : 0

  name                = "${var.resource_name}-http5xx-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.http_5xx.description} exceeded ${local.resolved.http_5xx.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.http_5xx.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.http_5xx.name
    aggregation      = local.metrics.http_5xx.aggregation
    operator         = local.metrics.http_5xx.operator
    threshold        = local.resolved.http_5xx.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "http_5xx_crit" {
  count = var.enabled && local.resolved.http_5xx.enabled ? 1 : 0

  name                = "${var.resource_name}-http5xx-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.http_5xx.description} exceeded ${local.resolved.http_5xx.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.http_5xx.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.http_5xx.name
    aggregation      = local.metrics.http_5xx.aggregation
    operator         = local.metrics.http_5xx.operator
    threshold        = local.resolved.http_5xx.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# HTTP 4xx Error Alerts
resource "azurerm_monitor_metric_alert" "http_4xx_warn" {
  count = var.enabled && local.resolved.http_4xx.enabled ? 1 : 0

  name                = "${var.resource_name}-http4xx-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.http_4xx.description} exceeded ${local.resolved.http_4xx.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.http_4xx.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.http_4xx.name
    aggregation      = local.metrics.http_4xx.aggregation
    operator         = local.metrics.http_4xx.operator
    threshold        = local.resolved.http_4xx.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "http_4xx_crit" {
  count = var.enabled && local.resolved.http_4xx.enabled ? 1 : 0

  name                = "${var.resource_name}-http4xx-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.http_4xx.description} exceeded ${local.resolved.http_4xx.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.http_4xx.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.http_4xx.name
    aggregation      = local.metrics.http_4xx.aggregation
    operator         = local.metrics.http_4xx.operator
    threshold        = local.resolved.http_4xx.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Response Time Alerts
resource "azurerm_monitor_metric_alert" "response_time_warn" {
  count = var.enabled && local.resolved.response_time.enabled ? 1 : 0

  name                = "${var.resource_name}-responsetime-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.response_time.description} exceeded ${local.resolved.response_time.warning_threshold}s"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.response_time.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.response_time.name
    aggregation      = local.metrics.response_time.aggregation
    operator         = local.metrics.response_time.operator
    threshold        = local.resolved.response_time.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "response_time_crit" {
  count = var.enabled && local.resolved.response_time.enabled ? 1 : 0

  name                = "${var.resource_name}-responsetime-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.response_time.description} exceeded ${local.resolved.response_time.critical_threshold}s"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.response_time.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.response_time.name
    aggregation      = local.metrics.response_time.aggregation
    operator         = local.metrics.response_time.operator
    threshold        = local.resolved.response_time.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Memory Working Set Alerts
resource "azurerm_monitor_metric_alert" "memory_warn" {
  count = var.enabled && local.resolved.memory.enabled ? 1 : 0

  name                = "${var.resource_name}-memory-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.memory.description} exceeded threshold"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.memory.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.memory.name
    aggregation      = local.metrics.memory.aggregation
    operator         = local.metrics.memory.operator
    threshold        = local.resolved.memory.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "memory_crit" {
  count = var.enabled && local.resolved.memory.enabled ? 1 : 0

  name                = "${var.resource_name}-memory-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.memory.description} exceeded threshold"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.memory.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.memory.name
    aggregation      = local.metrics.memory.aggregation
    operator         = local.metrics.memory.operator
    threshold        = local.resolved.memory.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Function Execution Count Alerts
resource "azurerm_monitor_metric_alert" "execution_count_warn" {
  count = var.enabled && local.resolved.execution_count.enabled ? 1 : 0

  name                = "${var.resource_name}-executions-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.execution_count.description} exceeded ${local.resolved.execution_count.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.execution_count.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.execution_count.name
    aggregation      = local.metrics.execution_count.aggregation
    operator         = local.metrics.execution_count.operator
    threshold        = local.resolved.execution_count.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "execution_count_crit" {
  count = var.enabled && local.resolved.execution_count.enabled ? 1 : 0

  name                = "${var.resource_name}-executions-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.execution_count.description} exceeded ${local.resolved.execution_count.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.execution_count.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.execution_count.name
    aggregation      = local.metrics.execution_count.aggregation
    operator         = local.metrics.execution_count.operator
    threshold        = local.resolved.execution_count.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
