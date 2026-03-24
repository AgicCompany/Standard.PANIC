# Tunnel Status Alert (critical only - tunnel down detection)
resource "azurerm_monitor_metric_alert" "tunnel_status_crit" {
  count = local.resolved.tunnel_status.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-tunnel-status-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.tunnel_status.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.tunnel_status.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.tunnel_status.name
    aggregation      = local.metrics.tunnel_status.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.tunnel_status.critical_threshold
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

# Tunnel Bandwidth Alerts
resource "azurerm_monitor_metric_alert" "tunnel_bandwidth_warn" {
  count = local.resolved.tunnel_bandwidth.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-tunnel-bw-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.tunnel_bandwidth.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.tunnel_bandwidth.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.tunnel_bandwidth.name
    aggregation      = local.metrics.tunnel_bandwidth.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.tunnel_bandwidth.warning_threshold
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

resource "azurerm_monitor_metric_alert" "tunnel_bandwidth_crit" {
  count = local.resolved.tunnel_bandwidth.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-tunnel-bw-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.tunnel_bandwidth.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.tunnel_bandwidth.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.tunnel_bandwidth.name
    aggregation      = local.metrics.tunnel_bandwidth.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.tunnel_bandwidth.critical_threshold
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

# P2S Bandwidth Alerts
resource "azurerm_monitor_metric_alert" "p2s_bandwidth_warn" {
  count = local.resolved.p2s_bandwidth.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-p2s-bw-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.p2s_bandwidth.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.p2s_bandwidth.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.p2s_bandwidth.name
    aggregation      = local.metrics.p2s_bandwidth.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.p2s_bandwidth.warning_threshold
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

resource "azurerm_monitor_metric_alert" "p2s_bandwidth_crit" {
  count = local.resolved.p2s_bandwidth.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-p2s-bw-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.p2s_bandwidth.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.p2s_bandwidth.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.p2s_bandwidth.name
    aggregation      = local.metrics.p2s_bandwidth.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.p2s_bandwidth.critical_threshold
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

# P2S Connection Count Alerts
resource "azurerm_monitor_metric_alert" "p2s_connection_count_warn" {
  count = local.resolved.p2s_connection_count.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-p2s-conn-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.p2s_connection_count.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.p2s_connection_count.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.p2s_connection_count.name
    aggregation      = local.metrics.p2s_connection_count.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.p2s_connection_count.warning_threshold
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

resource "azurerm_monitor_metric_alert" "p2s_connection_count_crit" {
  count = local.resolved.p2s_connection_count.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-p2s-conn-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.p2s_connection_count.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.p2s_connection_count.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.p2s_connection_count.name
    aggregation      = local.metrics.p2s_connection_count.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.p2s_connection_count.critical_threshold
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

# Tunnel Drop Count Alerts
resource "azurerm_monitor_metric_alert" "tunnel_drop_count_warn" {
  count = local.resolved.tunnel_drop_count.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-tunnel-drops-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.tunnel_drop_count.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.tunnel_drop_count.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.tunnel_drop_count.name
    aggregation      = local.metrics.tunnel_drop_count.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.tunnel_drop_count.warning_threshold
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

resource "azurerm_monitor_metric_alert" "tunnel_drop_count_crit" {
  count = local.resolved.tunnel_drop_count.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-tunnel-drops-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.tunnel_drop_count.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.tunnel_drop_count.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.tunnel_drop_count.name
    aggregation      = local.metrics.tunnel_drop_count.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.tunnel_drop_count.critical_threshold
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
