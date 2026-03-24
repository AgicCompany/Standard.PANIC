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

# Memory Utilization Alerts
resource "azurerm_monitor_metric_alert" "memory_warn" {
  count = var.enabled && local.resolved.memory.enabled ? 1 : 0

  name                = "${var.resource_name}-memory-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.memory.description} exceeded ${local.resolved.memory.warning_threshold}%"
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
  description         = "Critical: ${local.metrics.memory.description} exceeded ${local.resolved.memory.critical_threshold}%"
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

# Storage Utilization Alerts
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

# IO Consumption Alerts
resource "azurerm_monitor_metric_alert" "io_warn" {
  count = var.enabled && local.resolved.io.enabled ? 1 : 0

  name                = "${var.resource_name}-io-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.io.description} exceeded ${local.resolved.io.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.io.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.io.name
    aggregation      = local.metrics.io.aggregation
    operator         = local.metrics.io.operator
    threshold        = local.resolved.io.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "io_crit" {
  count = var.enabled && local.resolved.io.enabled ? 1 : 0

  name                = "${var.resource_name}-io-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.io.description} exceeded ${local.resolved.io.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.io.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.io.name
    aggregation      = local.metrics.io.aggregation
    operator         = local.metrics.io.operator
    threshold        = local.resolved.io.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Active Connections Alerts
resource "azurerm_monitor_metric_alert" "connections_warn" {
  count = var.enabled && local.resolved.connections.enabled ? 1 : 0

  name                = "${var.resource_name}-connections-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.connections.description} exceeded ${local.resolved.connections.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.connections.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.connections.name
    aggregation      = local.metrics.connections.aggregation
    operator         = local.metrics.connections.operator
    threshold        = local.resolved.connections.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "connections_crit" {
  count = var.enabled && local.resolved.connections.enabled ? 1 : 0

  name                = "${var.resource_name}-connections-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.connections.description} exceeded ${local.resolved.connections.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.connections.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.connections.name
    aggregation      = local.metrics.connections.aggregation
    operator         = local.metrics.connections.operator
    threshold        = local.resolved.connections.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Aborted Connections Alerts
resource "azurerm_monitor_metric_alert" "aborted_connections_warn" {
  count = var.enabled && local.resolved.aborted_connections.enabled ? 1 : 0

  name                = "${var.resource_name}-abortedconn-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.aborted_connections.description} exceeded ${local.resolved.aborted_connections.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.aborted_connections.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.aborted_connections.name
    aggregation      = local.metrics.aborted_connections.aggregation
    operator         = local.metrics.aborted_connections.operator
    threshold        = local.resolved.aborted_connections.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "aborted_connections_crit" {
  count = var.enabled && local.resolved.aborted_connections.enabled ? 1 : 0

  name                = "${var.resource_name}-abortedconn-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.aborted_connections.description} exceeded ${local.resolved.aborted_connections.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.aborted_connections.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.aborted_connections.name
    aggregation      = local.metrics.aborted_connections.aggregation
    operator         = local.metrics.aborted_connections.operator
    threshold        = local.resolved.aborted_connections.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Replication Lag Alerts (for read replicas)
resource "azurerm_monitor_metric_alert" "replication_lag_warn" {
  count = var.enabled && local.resolved.replication_lag.enabled ? 1 : 0

  name                = "${var.resource_name}-repllag-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.replication_lag.description} exceeded ${local.resolved.replication_lag.warning_threshold}s"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.replication_lag.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.replication_lag.name
    aggregation      = local.metrics.replication_lag.aggregation
    operator         = local.metrics.replication_lag.operator
    threshold        = local.resolved.replication_lag.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "replication_lag_crit" {
  count = var.enabled && local.resolved.replication_lag.enabled ? 1 : 0

  name                = "${var.resource_name}-repllag-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.replication_lag.description} exceeded ${local.resolved.replication_lag.critical_threshold}s"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.replication_lag.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.replication_lag.name
    aggregation      = local.metrics.replication_lag.aggregation
    operator         = local.metrics.replication_lag.operator
    threshold        = local.resolved.replication_lag.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
