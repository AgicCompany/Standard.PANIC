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

# HTTP 5xx - Warning Alert
resource "azurerm_monitor_metric_alert" "http_5xx_warn" {
  count = local.resolved.http_5xx.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-http5xx-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.http_5xx.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.http_5xx.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.http_5xx.namespace
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

# HTTP 5xx - Critical Alert
resource "azurerm_monitor_metric_alert" "http_5xx_crit" {
  count = local.resolved.http_5xx.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-http5xx-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.http_5xx.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.http_5xx.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.http_5xx.namespace
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

# Response Time - Warning Alert
resource "azurerm_monitor_metric_alert" "response_time_warn" {
  count = local.resolved.response_time.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-responsetime-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.response_time.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.response_time.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.response_time.namespace
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

# Response Time - Critical Alert
resource "azurerm_monitor_metric_alert" "response_time_crit" {
  count = local.resolved.response_time.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-responsetime-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.response_time.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.response_time.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.response_time.namespace
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

# Health Check - Critical Alert (no warning level for availability)
# Note: HealthCheckStatus requires minimum PT5M window
resource "azurerm_monitor_metric_alert" "health_check_crit" {
  count = local.resolved.health_check.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-health-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.health_check.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT5M"  # Minimum required by Azure for HealthCheckStatus

  criteria {
    metric_namespace = local.metrics.health_check.namespace
    metric_name      = local.metrics.health_check.name
    aggregation      = local.metrics.health_check.aggregation
    operator         = local.metrics.health_check.operator
    threshold        = local.resolved.health_check.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
