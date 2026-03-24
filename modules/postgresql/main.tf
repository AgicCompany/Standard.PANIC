# CPU - Warning Alert
resource "azurerm_monitor_metric_alert" "cpu_warn" {
  count = local.resolved.cpu.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-cpu-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.cpu.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.cpu.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.cpu.namespace
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

# CPU - Critical Alert
resource "azurerm_monitor_metric_alert" "cpu_crit" {
  count = local.resolved.cpu.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-cpu-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.cpu.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.cpu.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.cpu.namespace
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

# Memory - Warning Alert
resource "azurerm_monitor_metric_alert" "memory_warn" {
  count = local.resolved.memory.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-memory-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.memory.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.memory.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.memory.namespace
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

# Memory - Critical Alert
resource "azurerm_monitor_metric_alert" "memory_crit" {
  count = local.resolved.memory.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-memory-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.memory.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.memory.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.memory.namespace
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

# Storage - Warning Alert
resource "azurerm_monitor_metric_alert" "storage_warn" {
  count = local.resolved.storage.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-storage-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.storage.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.storage.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.storage.namespace
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

# Storage - Critical Alert
resource "azurerm_monitor_metric_alert" "storage_crit" {
  count = local.resolved.storage.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-storage-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.storage.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.storage.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.storage.namespace
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

# Active Connections - Warning Alert
resource "azurerm_monitor_metric_alert" "connections_warn" {
  count = local.resolved.connections.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-connections-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.connections.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.connections.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.connections.namespace
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

# Active Connections - Critical Alert
resource "azurerm_monitor_metric_alert" "connections_crit" {
  count = local.resolved.connections.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-connections-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.connections.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.connections.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.connections.namespace
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

# Failed Connections - Warning Alert
resource "azurerm_monitor_metric_alert" "failed_connections_warn" {
  count = local.resolved.failed_connections.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-failedconn-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.failed_connections.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.failed_connections.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.failed_connections.namespace
    metric_name      = local.metrics.failed_connections.name
    aggregation      = local.metrics.failed_connections.aggregation
    operator         = local.metrics.failed_connections.operator
    threshold        = local.resolved.failed_connections.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

# Failed Connections - Critical Alert
resource "azurerm_monitor_metric_alert" "failed_connections_crit" {
  count = local.resolved.failed_connections.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-failedconn-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.failed_connections.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.failed_connections.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.failed_connections.namespace
    metric_name      = local.metrics.failed_connections.name
    aggregation      = local.metrics.failed_connections.aggregation
    operator         = local.metrics.failed_connections.operator
    threshold        = local.resolved.failed_connections.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Database Availability - Critical Alert (no warning level)
resource "azurerm_monitor_metric_alert" "availability_crit" {
  count = local.resolved.availability.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-availability-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.availability.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.availability.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.availability.namespace
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

# Replication Lag - Warning Alert (disabled by default, for read replicas only)
resource "azurerm_monitor_metric_alert" "replication_lag_warn" {
  count = local.resolved.replication_lag.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-repllag-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.replication_lag.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.replication_lag.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.replication_lag.namespace
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

# Replication Lag - Critical Alert (disabled by default, for read replicas only)
resource "azurerm_monitor_metric_alert" "replication_lag_crit" {
  count = local.resolved.replication_lag.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-repllag-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.replication_lag.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.replication_lag.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.replication_lag.namespace
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
