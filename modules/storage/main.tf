# Availability - Warning Alert
resource "azurerm_monitor_metric_alert" "availability_warn" {
  count = local.resolved.availability.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-availability-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.availability.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.availability.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.availability.namespace
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

# Availability - Critical Alert
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

# Latency - Warning Alert
resource "azurerm_monitor_metric_alert" "latency_warn" {
  count = local.resolved.latency.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-latency-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.latency.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.latency.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.latency.namespace
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

# Latency - Critical Alert
resource "azurerm_monitor_metric_alert" "latency_crit" {
  count = local.resolved.latency.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-latency-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.latency.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.latency.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.latency.namespace
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

# Throttling - Warning Alert
resource "azurerm_monitor_metric_alert" "throttling_warn" {
  count = local.resolved.throttling.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-throttling-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.throttling.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.throttling.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.throttling.namespace
    metric_name      = local.metrics.throttling.name
    aggregation      = local.metrics.throttling.aggregation
    operator         = local.metrics.throttling.operator
    threshold        = local.resolved.throttling.warning_threshold

    dynamic "dimension" {
      for_each = local.metrics.throttling.dimensions
      content {
        name     = dimension.value.name
        operator = dimension.value.operator
        values   = dimension.value.values
      }
    }
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

# Throttling - Critical Alert
resource "azurerm_monitor_metric_alert" "throttling_crit" {
  count = local.resolved.throttling.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-throttling-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.throttling.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.throttling.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.throttling.namespace
    metric_name      = local.metrics.throttling.name
    aggregation      = local.metrics.throttling.aggregation
    operator         = local.metrics.throttling.operator
    threshold        = local.resolved.throttling.critical_threshold

    dynamic "dimension" {
      for_each = local.metrics.throttling.dimensions
      content {
        name     = dimension.value.name
        operator = dimension.value.operator
        values   = dimension.value.values
      }
    }
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Used Capacity - Warning Alert
# Note: UsedCapacity metric requires minimum PT1H window
resource "azurerm_monitor_metric_alert" "used_capacity_warn" {
  count = local.resolved.used_capacity.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-capacity-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.used_capacity.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT1H"

  criteria {
    metric_namespace = local.metrics.used_capacity.namespace
    metric_name      = local.metrics.used_capacity.name
    aggregation      = local.metrics.used_capacity.aggregation
    operator         = local.metrics.used_capacity.operator
    threshold        = local.resolved.used_capacity.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

# Used Capacity - Critical Alert
# Note: UsedCapacity metric requires minimum PT1H window
resource "azurerm_monitor_metric_alert" "used_capacity_crit" {
  count = local.resolved.used_capacity.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-capacity-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.used_capacity.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT1H"

  criteria {
    metric_namespace = local.metrics.used_capacity.namespace
    metric_name      = local.metrics.used_capacity.name
    aggregation      = local.metrics.used_capacity.aggregation
    operator         = local.metrics.used_capacity.operator
    threshold        = local.resolved.used_capacity.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
