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

# Quota Exceeded Errors Alerts
resource "azurerm_monitor_metric_alert" "quota_exceeded_warn" {
  count = var.enabled && local.resolved.quota_exceeded.enabled ? 1 : 0

  name                = "${var.resource_name}-quotaexceeded-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.quota_exceeded.description} exceeded ${local.resolved.quota_exceeded.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.quota_exceeded.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.quota_exceeded.name
    aggregation      = local.metrics.quota_exceeded.aggregation
    operator         = local.metrics.quota_exceeded.operator
    threshold        = local.resolved.quota_exceeded.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "quota_exceeded_crit" {
  count = var.enabled && local.resolved.quota_exceeded.enabled ? 1 : 0

  name                = "${var.resource_name}-quotaexceeded-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.quota_exceeded.description} exceeded ${local.resolved.quota_exceeded.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.quota_exceeded.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.quota_exceeded.name
    aggregation      = local.metrics.quota_exceeded.aggregation
    operator         = local.metrics.quota_exceeded.operator
    threshold        = local.resolved.quota_exceeded.critical_threshold
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

# Incoming Messages Alerts
resource "azurerm_monitor_metric_alert" "incoming_messages_warn" {
  count = var.enabled && local.resolved.incoming_messages.enabled ? 1 : 0

  name                = "${var.resource_name}-incomingmsg-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.incoming_messages.description} exceeded ${local.resolved.incoming_messages.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.incoming_messages.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.incoming_messages.name
    aggregation      = local.metrics.incoming_messages.aggregation
    operator         = local.metrics.incoming_messages.operator
    threshold        = local.resolved.incoming_messages.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "incoming_messages_crit" {
  count = var.enabled && local.resolved.incoming_messages.enabled ? 1 : 0

  name                = "${var.resource_name}-incomingmsg-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.incoming_messages.description} exceeded ${local.resolved.incoming_messages.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.incoming_messages.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.incoming_messages.name
    aggregation      = local.metrics.incoming_messages.aggregation
    operator         = local.metrics.incoming_messages.operator
    threshold        = local.resolved.incoming_messages.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Capture Backlog Alerts
resource "azurerm_monitor_metric_alert" "capture_backlog_warn" {
  count = var.enabled && local.resolved.capture_backlog.enabled ? 1 : 0

  name                = "${var.resource_name}-capturebacklog-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.capture_backlog.description} exceeded ${local.resolved.capture_backlog.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.capture_backlog.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.capture_backlog.name
    aggregation      = local.metrics.capture_backlog.aggregation
    operator         = local.metrics.capture_backlog.operator
    threshold        = local.resolved.capture_backlog.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "capture_backlog_crit" {
  count = var.enabled && local.resolved.capture_backlog.enabled ? 1 : 0

  name                = "${var.resource_name}-capturebacklog-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.capture_backlog.description} exceeded ${local.resolved.capture_backlog.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.capture_backlog.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.capture_backlog.name
    aggregation      = local.metrics.capture_backlog.aggregation
    operator         = local.metrics.capture_backlog.operator
    threshold        = local.resolved.capture_backlog.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
