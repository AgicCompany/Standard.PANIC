# Normalized RU Consumption Alerts
resource "azurerm_monitor_metric_alert" "ru_consumption_warn" {
  count = var.enabled && local.resolved.ru_consumption.enabled ? 1 : 0

  name                = "${var.resource_name}-ru-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.ru_consumption.description} exceeded ${local.resolved.ru_consumption.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.ru_consumption.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.ru_consumption.name
    aggregation      = local.metrics.ru_consumption.aggregation
    operator         = local.metrics.ru_consumption.operator
    threshold        = local.resolved.ru_consumption.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "ru_consumption_crit" {
  count = var.enabled && local.resolved.ru_consumption.enabled ? 1 : 0

  name                = "${var.resource_name}-ru-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.ru_consumption.description} exceeded ${local.resolved.ru_consumption.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.ru_consumption.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.ru_consumption.name
    aggregation      = local.metrics.ru_consumption.aggregation
    operator         = local.metrics.ru_consumption.operator
    threshold        = local.resolved.ru_consumption.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Service Availability Alerts
resource "azurerm_monitor_metric_alert" "availability_warn" {
  count = var.enabled && local.resolved.availability.enabled ? 1 : 0

  name                = "${var.resource_name}-availability-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.availability.description} below ${local.resolved.availability.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.availability.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.availability.name
    aggregation      = local.metrics.availability.aggregation
    operator         = local.metrics.availability.operator
    threshold        = local.resolved.availability.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "availability_crit" {
  count = var.enabled && local.resolved.availability.enabled ? 1 : 0

  name                = "${var.resource_name}-availability-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.availability.description} below ${local.resolved.availability.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.availability.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.availability.name
    aggregation      = local.metrics.availability.aggregation
    operator         = local.metrics.availability.operator
    threshold        = local.resolved.availability.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Server-Side Latency Alerts
resource "azurerm_monitor_metric_alert" "server_latency_warn" {
  count = var.enabled && local.resolved.server_latency.enabled ? 1 : 0

  name                = "${var.resource_name}-latency-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.server_latency.description} exceeded ${local.resolved.server_latency.warning_threshold}ms"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.server_latency.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.server_latency.name
    aggregation      = local.metrics.server_latency.aggregation
    operator         = local.metrics.server_latency.operator
    threshold        = local.resolved.server_latency.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "server_latency_crit" {
  count = var.enabled && local.resolved.server_latency.enabled ? 1 : 0

  name                = "${var.resource_name}-latency-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.server_latency.description} exceeded ${local.resolved.server_latency.critical_threshold}ms"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.server_latency.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.server_latency.name
    aggregation      = local.metrics.server_latency.aggregation
    operator         = local.metrics.server_latency.operator
    threshold        = local.resolved.server_latency.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Throttled Requests (429) Alerts
resource "azurerm_monitor_metric_alert" "throttled_requests_warn" {
  count = var.enabled && local.resolved.throttled_requests.enabled ? 1 : 0

  name                = "${var.resource_name}-throttled-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.throttled_requests.description} exceeded ${local.resolved.throttled_requests.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.throttled_requests.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.throttled_requests.name
    aggregation      = local.metrics.throttled_requests.aggregation
    operator         = local.metrics.throttled_requests.operator
    threshold        = local.resolved.throttled_requests.warning_threshold

    dimension {
      name     = "StatusCode"
      operator = "Include"
      values   = ["429"]
    }
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "throttled_requests_crit" {
  count = var.enabled && local.resolved.throttled_requests.enabled ? 1 : 0

  name                = "${var.resource_name}-throttled-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.throttled_requests.description} exceeded ${local.resolved.throttled_requests.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.throttled_requests.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.throttled_requests.name
    aggregation      = local.metrics.throttled_requests.aggregation
    operator         = local.metrics.throttled_requests.operator
    threshold        = local.resolved.throttled_requests.critical_threshold

    dimension {
      name     = "StatusCode"
      operator = "Include"
      values   = ["429"]
    }
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Total Requests Alerts (for anomaly detection baseline)
resource "azurerm_monitor_metric_alert" "total_requests_warn" {
  count = var.enabled && local.resolved.total_requests.enabled ? 1 : 0

  name                = "${var.resource_name}-requests-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.total_requests.description} exceeded ${local.resolved.total_requests.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.total_requests.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.total_requests.name
    aggregation      = local.metrics.total_requests.aggregation
    operator         = local.metrics.total_requests.operator
    threshold        = local.resolved.total_requests.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "total_requests_crit" {
  count = var.enabled && local.resolved.total_requests.enabled ? 1 : 0

  name                = "${var.resource_name}-requests-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.total_requests.description} exceeded ${local.resolved.total_requests.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.total_requests.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.total_requests.name
    aggregation      = local.metrics.total_requests.aggregation
    operator         = local.metrics.total_requests.operator
    threshold        = local.resolved.total_requests.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
