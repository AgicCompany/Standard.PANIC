# Health State Alerts
resource "azurerm_monitor_metric_alert" "health_state_warn" {
  count = local.resolved.health_state.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-health-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.health_state.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.health_state.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.health_state.name
    aggregation      = local.metrics.health_state.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.health_state.warning_threshold
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

resource "azurerm_monitor_metric_alert" "health_state_crit" {
  count = local.resolved.health_state.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-health-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.health_state.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.health_state.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.health_state.name
    aggregation      = local.metrics.health_state.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.health_state.critical_threshold
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

# Throughput Alerts
resource "azurerm_monitor_metric_alert" "throughput_warn" {
  count = local.resolved.throughput.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-throughput-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.throughput.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.throughput.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.throughput.name
    aggregation      = local.metrics.throughput.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.throughput.warning_threshold
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

resource "azurerm_monitor_metric_alert" "throughput_crit" {
  count = local.resolved.throughput.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-throughput-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.throughput.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.throughput.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.throughput.name
    aggregation      = local.metrics.throughput.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.throughput.critical_threshold
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

# SNAT Port Utilization Alerts
resource "azurerm_monitor_metric_alert" "snat_port_utilization_warn" {
  count = local.resolved.snat_port_utilization.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-snat-util-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.snat_port_utilization.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.snat_port_utilization.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.snat_port_utilization.name
    aggregation      = local.metrics.snat_port_utilization.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.snat_port_utilization.warning_threshold
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

resource "azurerm_monitor_metric_alert" "snat_port_utilization_crit" {
  count = local.resolved.snat_port_utilization.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-snat-util-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.snat_port_utilization.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.snat_port_utilization.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.snat_port_utilization.name
    aggregation      = local.metrics.snat_port_utilization.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.snat_port_utilization.critical_threshold
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

# Latency Alerts
resource "azurerm_monitor_metric_alert" "latency_warn" {
  count = local.resolved.latency.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-latency-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.latency.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.latency.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.latency.name
    aggregation      = local.metrics.latency.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.latency.warning_threshold
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

resource "azurerm_monitor_metric_alert" "latency_crit" {
  count = local.resolved.latency.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-latency-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.latency.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.latency.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.latency.name
    aggregation      = local.metrics.latency.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.latency.critical_threshold
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
