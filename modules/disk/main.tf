# IOPS Consumed Alerts
resource "azurerm_monitor_metric_alert" "iops_consumed_warn" {
  count = local.resolved.iops_consumed.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-iops-consumed-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.iops_consumed.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.iops_consumed.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.iops_consumed.name
    aggregation      = local.metrics.iops_consumed.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.iops_consumed.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = merge(var.tags, {
    managed-by = "terraform"
    profile    = var.profile
    severity   = "warning"
  })
}

resource "azurerm_monitor_metric_alert" "iops_consumed_crit" {
  count = local.resolved.iops_consumed.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-iops-consumed-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.iops_consumed.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.iops_consumed.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.iops_consumed.name
    aggregation      = local.metrics.iops_consumed.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.iops_consumed.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = merge(var.tags, {
    managed-by = "terraform"
    profile    = var.profile
    severity   = "critical"
  })
}

# Bandwidth Consumed Alerts
resource "azurerm_monitor_metric_alert" "bandwidth_consumed_warn" {
  count = local.resolved.bandwidth_consumed.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-bandwidth-consumed-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.bandwidth_consumed.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.bandwidth_consumed.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.bandwidth_consumed.name
    aggregation      = local.metrics.bandwidth_consumed.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.bandwidth_consumed.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = merge(var.tags, {
    managed-by = "terraform"
    profile    = var.profile
    severity   = "warning"
  })
}

resource "azurerm_monitor_metric_alert" "bandwidth_consumed_crit" {
  count = local.resolved.bandwidth_consumed.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-bandwidth-consumed-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.bandwidth_consumed.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.bandwidth_consumed.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.bandwidth_consumed.name
    aggregation      = local.metrics.bandwidth_consumed.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.bandwidth_consumed.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = merge(var.tags, {
    managed-by = "terraform"
    profile    = var.profile
    severity   = "critical"
  })
}

# Queue Depth Alerts
resource "azurerm_monitor_metric_alert" "queue_depth_warn" {
  count = local.resolved.queue_depth.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-queue-depth-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.queue_depth.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.queue_depth.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.queue_depth.name
    aggregation      = local.metrics.queue_depth.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.queue_depth.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = merge(var.tags, {
    managed-by = "terraform"
    profile    = var.profile
    severity   = "warning"
  })
}

resource "azurerm_monitor_metric_alert" "queue_depth_crit" {
  count = local.resolved.queue_depth.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-queue-depth-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.queue_depth.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.queue_depth.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.queue_depth.name
    aggregation      = local.metrics.queue_depth.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.queue_depth.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = merge(var.tags, {
    managed-by = "terraform"
    profile    = var.profile
    severity   = "critical"
  })
}

# Burst BPS Credits Alerts (lower is worse)
resource "azurerm_monitor_metric_alert" "burst_bps_credits_warn" {
  count = local.resolved.burst_bps_credits.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-burst-bps-credits-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.burst_bps_credits.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.burst_bps_credits.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.burst_bps_credits.name
    aggregation      = local.metrics.burst_bps_credits.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.burst_bps_credits.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = merge(var.tags, {
    managed-by = "terraform"
    profile    = var.profile
    severity   = "warning"
  })
}

resource "azurerm_monitor_metric_alert" "burst_bps_credits_crit" {
  count = local.resolved.burst_bps_credits.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-burst-bps-credits-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.burst_bps_credits.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.burst_bps_credits.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.burst_bps_credits.name
    aggregation      = local.metrics.burst_bps_credits.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.burst_bps_credits.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = merge(var.tags, {
    managed-by = "terraform"
    profile    = var.profile
    severity   = "critical"
  })
}

# Burst IO Credits Alerts (lower is worse)
resource "azurerm_monitor_metric_alert" "burst_io_credits_warn" {
  count = local.resolved.burst_io_credits.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-burst-io-credits-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.burst_io_credits.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.burst_io_credits.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.burst_io_credits.name
    aggregation      = local.metrics.burst_io_credits.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.burst_io_credits.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = merge(var.tags, {
    managed-by = "terraform"
    profile    = var.profile
    severity   = "warning"
  })
}

resource "azurerm_monitor_metric_alert" "burst_io_credits_crit" {
  count = local.resolved.burst_io_credits.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-burst-io-credits-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.burst_io_credits.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.burst_io_credits.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.burst_io_credits.name
    aggregation      = local.metrics.burst_io_credits.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.burst_io_credits.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = merge(var.tags, {
    managed-by = "terraform"
    profile    = var.profile
    severity   = "critical"
  })
}
