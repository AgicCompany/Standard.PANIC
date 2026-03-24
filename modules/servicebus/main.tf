# Active Messages Alerts
resource "azurerm_monitor_metric_alert" "active_messages_warn" {
  count = var.enabled && local.resolved.active_messages.enabled ? 1 : 0

  name                = "${var.resource_name}-activemsg-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.active_messages.description} exceeded ${local.resolved.active_messages.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.active_messages.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.active_messages.name
    aggregation      = local.metrics.active_messages.aggregation
    operator         = local.metrics.active_messages.operator
    threshold        = local.resolved.active_messages.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "active_messages_crit" {
  count = var.enabled && local.resolved.active_messages.enabled ? 1 : 0

  name                = "${var.resource_name}-activemsg-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.active_messages.description} exceeded ${local.resolved.active_messages.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.active_messages.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.active_messages.name
    aggregation      = local.metrics.active_messages.aggregation
    operator         = local.metrics.active_messages.operator
    threshold        = local.resolved.active_messages.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Dead-lettered Messages Alerts
resource "azurerm_monitor_metric_alert" "deadlettered_messages_warn" {
  count = var.enabled && local.resolved.deadlettered_messages.enabled ? 1 : 0

  name                = "${var.resource_name}-deadletter-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.deadlettered_messages.description} exceeded ${local.resolved.deadlettered_messages.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.deadlettered_messages.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.deadlettered_messages.name
    aggregation      = local.metrics.deadlettered_messages.aggregation
    operator         = local.metrics.deadlettered_messages.operator
    threshold        = local.resolved.deadlettered_messages.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "deadlettered_messages_crit" {
  count = var.enabled && local.resolved.deadlettered_messages.enabled ? 1 : 0

  name                = "${var.resource_name}-deadletter-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.deadlettered_messages.description} exceeded ${local.resolved.deadlettered_messages.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.deadlettered_messages.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.deadlettered_messages.name
    aggregation      = local.metrics.deadlettered_messages.aggregation
    operator         = local.metrics.deadlettered_messages.operator
    threshold        = local.resolved.deadlettered_messages.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Throttled Requests Alerts
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
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Server Errors Alerts
resource "azurerm_monitor_metric_alert" "server_errors_warn" {
  count = var.enabled && local.resolved.server_errors.enabled ? 1 : 0

  name                = "${var.resource_name}-servererrors-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.server_errors.description} exceeded ${local.resolved.server_errors.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.server_errors.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.server_errors.name
    aggregation      = local.metrics.server_errors.aggregation
    operator         = local.metrics.server_errors.operator
    threshold        = local.resolved.server_errors.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "server_errors_crit" {
  count = var.enabled && local.resolved.server_errors.enabled ? 1 : 0

  name                = "${var.resource_name}-servererrors-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.server_errors.description} exceeded ${local.resolved.server_errors.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.server_errors.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.server_errors.name
    aggregation      = local.metrics.server_errors.aggregation
    operator         = local.metrics.server_errors.operator
    threshold        = local.resolved.server_errors.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Namespace Size Alerts
resource "azurerm_monitor_metric_alert" "size_warn" {
  count = var.enabled && local.resolved.size.enabled ? 1 : 0

  name                = "${var.resource_name}-size-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.size.description} exceeded threshold"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.size.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.size.name
    aggregation      = local.metrics.size.aggregation
    operator         = local.metrics.size.operator
    threshold        = local.resolved.size.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "size_crit" {
  count = var.enabled && local.resolved.size.enabled ? 1 : 0

  name                = "${var.resource_name}-size-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.size.description} exceeded threshold"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.size.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.size.name
    aggregation      = local.metrics.size.aggregation
    operator         = local.metrics.size.operator
    threshold        = local.resolved.size.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
