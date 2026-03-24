# CPU Usage Alerts
resource "azurerm_monitor_metric_alert" "cpu_warn" {
  count = var.enabled && local.resolved.cpu.enabled ? 1 : 0

  name                = "${var.resource_name}-cpu-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.cpu.description} exceeded threshold"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.cpu.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.cpu.name
    aggregation      = local.metrics.cpu.aggregation
    operator         = local.metrics.cpu.operator
    threshold        = local.resolved.cpu.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "cpu_crit" {
  count = var.enabled && local.resolved.cpu.enabled ? 1 : 0

  name                = "${var.resource_name}-cpu-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.cpu.description} exceeded threshold"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.cpu.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.cpu.name
    aggregation      = local.metrics.cpu.aggregation
    operator         = local.metrics.cpu.operator
    threshold        = local.resolved.cpu.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Memory Usage Alerts
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

# Restart Count Alerts
resource "azurerm_monitor_metric_alert" "restarts_warn" {
  count = var.enabled && local.resolved.restarts.enabled ? 1 : 0

  name                = "${var.resource_name}-restarts-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.restarts.description} exceeded ${local.resolved.restarts.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.restarts.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.restarts.name
    aggregation      = local.metrics.restarts.aggregation
    operator         = local.metrics.restarts.operator
    threshold        = local.resolved.restarts.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "restarts_crit" {
  count = var.enabled && local.resolved.restarts.enabled ? 1 : 0

  name                = "${var.resource_name}-restarts-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.restarts.description} exceeded ${local.resolved.restarts.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.restarts.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.restarts.name
    aggregation      = local.metrics.restarts.aggregation
    operator         = local.metrics.restarts.operator
    threshold        = local.resolved.restarts.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Replica Count Alerts
resource "azurerm_monitor_metric_alert" "replicas_warn" {
  count = var.enabled && local.resolved.replicas.enabled ? 1 : 0

  name                = "${var.resource_name}-replicas-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.replicas.description} below ${local.resolved.replicas.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.replicas.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.replicas.name
    aggregation      = local.metrics.replicas.aggregation
    operator         = local.metrics.replicas.operator
    threshold        = local.resolved.replicas.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "replicas_crit" {
  count = var.enabled && local.resolved.replicas.enabled ? 1 : 0

  name                = "${var.resource_name}-replicas-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.replicas.description} below ${local.resolved.replicas.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.replicas.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.replicas.name
    aggregation      = local.metrics.replicas.aggregation
    operator         = local.metrics.replicas.operator
    threshold        = local.resolved.replicas.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Request Count Alerts
resource "azurerm_monitor_metric_alert" "requests_warn" {
  count = var.enabled && local.resolved.requests.enabled ? 1 : 0

  name                = "${var.resource_name}-requests-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.requests.description} exceeded ${local.resolved.requests.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.requests.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.requests.name
    aggregation      = local.metrics.requests.aggregation
    operator         = local.metrics.requests.operator
    threshold        = local.resolved.requests.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "requests_crit" {
  count = var.enabled && local.resolved.requests.enabled ? 1 : 0

  name                = "${var.resource_name}-requests-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.requests.description} exceeded ${local.resolved.requests.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.requests.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.requests.name
    aggregation      = local.metrics.requests.aggregation
    operator         = local.metrics.requests.operator
    threshold        = local.resolved.requests.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
