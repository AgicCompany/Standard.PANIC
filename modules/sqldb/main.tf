# CPU Utilization Alerts
resource "azurerm_monitor_metric_alert" "cpu_warn" {
  count = var.enabled && local.resolved.cpu.enabled ? 1 : 0

  name                = "${var.resource_name}-cpu-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.cpu.description} exceeded ${local.resolved.cpu.warning_threshold}%"
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
  description         = "Critical: ${local.metrics.cpu.description} exceeded ${local.resolved.cpu.critical_threshold}%"
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

# DTU Consumption Alerts
resource "azurerm_monitor_metric_alert" "dtu_warn" {
  count = var.enabled && local.resolved.dtu.enabled ? 1 : 0

  name                = "${var.resource_name}-dtu-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.dtu.description} exceeded ${local.resolved.dtu.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.dtu.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.dtu.name
    aggregation      = local.metrics.dtu.aggregation
    operator         = local.metrics.dtu.operator
    threshold        = local.resolved.dtu.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "dtu_crit" {
  count = var.enabled && local.resolved.dtu.enabled ? 1 : 0

  name                = "${var.resource_name}-dtu-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.dtu.description} exceeded ${local.resolved.dtu.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.dtu.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.dtu.name
    aggregation      = local.metrics.dtu.aggregation
    operator         = local.metrics.dtu.operator
    threshold        = local.resolved.dtu.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Storage Percentage Alerts
resource "azurerm_monitor_metric_alert" "storage_warn" {
  count = var.enabled && local.resolved.storage.enabled ? 1 : 0

  name                = "${var.resource_name}-storage-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.storage.description} exceeded ${local.resolved.storage.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.storage.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.storage.name
    aggregation      = local.metrics.storage.aggregation
    operator         = local.metrics.storage.operator
    threshold        = local.resolved.storage.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "storage_crit" {
  count = var.enabled && local.resolved.storage.enabled ? 1 : 0

  name                = "${var.resource_name}-storage-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.storage.description} exceeded ${local.resolved.storage.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.storage.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.storage.name
    aggregation      = local.metrics.storage.aggregation
    operator         = local.metrics.storage.operator
    threshold        = local.resolved.storage.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Deadlock Alerts
resource "azurerm_monitor_metric_alert" "deadlocks_warn" {
  count = var.enabled && local.resolved.deadlocks.enabled ? 1 : 0

  name                = "${var.resource_name}-deadlocks-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.deadlocks.description} exceeded ${local.resolved.deadlocks.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.deadlocks.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.deadlocks.name
    aggregation      = local.metrics.deadlocks.aggregation
    operator         = local.metrics.deadlocks.operator
    threshold        = local.resolved.deadlocks.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "deadlocks_crit" {
  count = var.enabled && local.resolved.deadlocks.enabled ? 1 : 0

  name                = "${var.resource_name}-deadlocks-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.deadlocks.description} exceeded ${local.resolved.deadlocks.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.deadlocks.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.deadlocks.name
    aggregation      = local.metrics.deadlocks.aggregation
    operator         = local.metrics.deadlocks.operator
    threshold        = local.resolved.deadlocks.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Connection Failed Alerts
resource "azurerm_monitor_metric_alert" "connection_failed_warn" {
  count = var.enabled && local.resolved.connection_failed.enabled ? 1 : 0

  name                = "${var.resource_name}-connfail-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.connection_failed.description} exceeded ${local.resolved.connection_failed.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.connection_failed.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.connection_failed.name
    aggregation      = local.metrics.connection_failed.aggregation
    operator         = local.metrics.connection_failed.operator
    threshold        = local.resolved.connection_failed.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "connection_failed_crit" {
  count = var.enabled && local.resolved.connection_failed.enabled ? 1 : 0

  name                = "${var.resource_name}-connfail-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.connection_failed.description} exceeded ${local.resolved.connection_failed.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.connection_failed.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.connection_failed.name
    aggregation      = local.metrics.connection_failed.aggregation
    operator         = local.metrics.connection_failed.operator
    threshold        = local.resolved.connection_failed.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Sessions Percentage Alerts
resource "azurerm_monitor_metric_alert" "sessions_warn" {
  count = var.enabled && local.resolved.sessions.enabled ? 1 : 0

  name                = "${var.resource_name}-sessions-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.sessions.description} exceeded ${local.resolved.sessions.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.sessions.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.sessions.name
    aggregation      = local.metrics.sessions.aggregation
    operator         = local.metrics.sessions.operator
    threshold        = local.resolved.sessions.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "sessions_crit" {
  count = var.enabled && local.resolved.sessions.enabled ? 1 : 0

  name                = "${var.resource_name}-sessions-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.sessions.description} exceeded ${local.resolved.sessions.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.sessions.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.sessions.name
    aggregation      = local.metrics.sessions.aggregation
    operator         = local.metrics.sessions.operator
    threshold        = local.resolved.sessions.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Workers Percentage Alerts
resource "azurerm_monitor_metric_alert" "workers_warn" {
  count = var.enabled && local.resolved.workers.enabled ? 1 : 0

  name                = "${var.resource_name}-workers-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.workers.description} exceeded ${local.resolved.workers.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.workers.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.workers.name
    aggregation      = local.metrics.workers.aggregation
    operator         = local.metrics.workers.operator
    threshold        = local.resolved.workers.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "workers_crit" {
  count = var.enabled && local.resolved.workers.enabled ? 1 : 0

  name                = "${var.resource_name}-workers-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.workers.description} exceeded ${local.resolved.workers.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.workers.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.workers.name
    aggregation      = local.metrics.workers.aggregation
    operator         = local.metrics.workers.operator
    threshold        = local.resolved.workers.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
