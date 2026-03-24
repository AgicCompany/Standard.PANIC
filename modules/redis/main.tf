# Server Load Alerts
resource "azurerm_monitor_metric_alert" "server_load_warn" {
  count = var.enabled && local.resolved.server_load.enabled ? 1 : 0

  name                = "${var.resource_name}-serverload-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.server_load.description} exceeded ${local.resolved.server_load.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.server_load.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.server_load.name
    aggregation      = local.metrics.server_load.aggregation
    operator         = local.metrics.server_load.operator
    threshold        = local.resolved.server_load.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "server_load_crit" {
  count = var.enabled && local.resolved.server_load.enabled ? 1 : 0

  name                = "${var.resource_name}-serverload-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.server_load.description} exceeded ${local.resolved.server_load.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.server_load.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.server_load.name
    aggregation      = local.metrics.server_load.aggregation
    operator         = local.metrics.server_load.operator
    threshold        = local.resolved.server_load.critical_threshold
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

# Connected Clients Alerts
resource "azurerm_monitor_metric_alert" "connected_clients_warn" {
  count = var.enabled && local.resolved.connected_clients.enabled ? 1 : 0

  name                = "${var.resource_name}-clients-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.connected_clients.description} exceeded ${local.resolved.connected_clients.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.connected_clients.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.connected_clients.name
    aggregation      = local.metrics.connected_clients.aggregation
    operator         = local.metrics.connected_clients.operator
    threshold        = local.resolved.connected_clients.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "connected_clients_crit" {
  count = var.enabled && local.resolved.connected_clients.enabled ? 1 : 0

  name                = "${var.resource_name}-clients-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.connected_clients.description} exceeded ${local.resolved.connected_clients.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.connected_clients.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.connected_clients.name
    aggregation      = local.metrics.connected_clients.aggregation
    operator         = local.metrics.connected_clients.operator
    threshold        = local.resolved.connected_clients.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Cache Miss Rate Alerts
resource "azurerm_monitor_metric_alert" "cache_miss_rate_warn" {
  count = var.enabled && local.resolved.cache_miss_rate.enabled ? 1 : 0

  name                = "${var.resource_name}-cachemiss-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.cache_miss_rate.description} exceeded ${local.resolved.cache_miss_rate.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.cache_miss_rate.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.cache_miss_rate.name
    aggregation      = local.metrics.cache_miss_rate.aggregation
    operator         = local.metrics.cache_miss_rate.operator
    threshold        = local.resolved.cache_miss_rate.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "cache_miss_rate_crit" {
  count = var.enabled && local.resolved.cache_miss_rate.enabled ? 1 : 0

  name                = "${var.resource_name}-cachemiss-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.cache_miss_rate.description} exceeded ${local.resolved.cache_miss_rate.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.cache_miss_rate.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.cache_miss_rate.name
    aggregation      = local.metrics.cache_miss_rate.aggregation
    operator         = local.metrics.cache_miss_rate.operator
    threshold        = local.resolved.cache_miss_rate.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Evicted Keys Alerts
resource "azurerm_monitor_metric_alert" "evicted_keys_warn" {
  count = var.enabled && local.resolved.evicted_keys.enabled ? 1 : 0

  name                = "${var.resource_name}-evictedkeys-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.evicted_keys.description} exceeded ${local.resolved.evicted_keys.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.evicted_keys.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.evicted_keys.name
    aggregation      = local.metrics.evicted_keys.aggregation
    operator         = local.metrics.evicted_keys.operator
    threshold        = local.resolved.evicted_keys.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "evicted_keys_crit" {
  count = var.enabled && local.resolved.evicted_keys.enabled ? 1 : 0

  name                = "${var.resource_name}-evictedkeys-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.evicted_keys.description} exceeded ${local.resolved.evicted_keys.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.evicted_keys.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.evicted_keys.name
    aggregation      = local.metrics.evicted_keys.aggregation
    operator         = local.metrics.evicted_keys.operator
    threshold        = local.resolved.evicted_keys.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
