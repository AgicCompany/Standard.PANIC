# Availability Alerts
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

# API Latency Alerts
resource "azurerm_monitor_metric_alert" "latency_warn" {
  count = var.enabled && local.resolved.latency.enabled ? 1 : 0

  name                = "${var.resource_name}-latency-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.latency.description} exceeded ${local.resolved.latency.warning_threshold}ms"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.latency.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.latency.name
    aggregation      = local.metrics.latency.aggregation
    operator         = local.metrics.latency.operator
    threshold        = local.resolved.latency.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "latency_crit" {
  count = var.enabled && local.resolved.latency.enabled ? 1 : 0

  name                = "${var.resource_name}-latency-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.latency.description} exceeded ${local.resolved.latency.critical_threshold}ms"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.latency.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.latency.name
    aggregation      = local.metrics.latency.aggregation
    operator         = local.metrics.latency.operator
    threshold        = local.resolved.latency.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Saturation Alerts
resource "azurerm_monitor_metric_alert" "saturation_warn" {
  count = var.enabled && local.resolved.saturation.enabled ? 1 : 0

  name                = "${var.resource_name}-saturation-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.saturation.description} exceeded ${local.resolved.saturation.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.saturation.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.saturation.name
    aggregation      = local.metrics.saturation.aggregation
    operator         = local.metrics.saturation.operator
    threshold        = local.resolved.saturation.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "saturation_crit" {
  count = var.enabled && local.resolved.saturation.enabled ? 1 : 0

  name                = "${var.resource_name}-saturation-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.saturation.description} exceeded ${local.resolved.saturation.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.saturation.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.saturation.name
    aggregation      = local.metrics.saturation.aggregation
    operator         = local.metrics.saturation.operator
    threshold        = local.resolved.saturation.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# API Hits Alerts
resource "azurerm_monitor_metric_alert" "api_hits_warn" {
  count = var.enabled && local.resolved.api_hits.enabled ? 1 : 0

  name                = "${var.resource_name}-apihits-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.api_hits.description} exceeded ${local.resolved.api_hits.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.api_hits.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.api_hits.name
    aggregation      = local.metrics.api_hits.aggregation
    operator         = local.metrics.api_hits.operator
    threshold        = local.resolved.api_hits.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "api_hits_crit" {
  count = var.enabled && local.resolved.api_hits.enabled ? 1 : 0

  name                = "${var.resource_name}-apihits-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.api_hits.description} exceeded ${local.resolved.api_hits.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.api_hits.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.api_hits.name
    aggregation      = local.metrics.api_hits.aggregation
    operator         = local.metrics.api_hits.operator
    threshold        = local.resolved.api_hits.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
