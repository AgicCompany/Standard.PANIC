# Unhealthy Hosts Alerts
resource "azurerm_monitor_metric_alert" "unhealthy_hosts_warn" {
  count = local.resolved.unhealthy_hosts.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-unhealthy-hosts-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.unhealthy_hosts.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.unhealthy_hosts.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.unhealthy_hosts.name
    aggregation      = local.metrics.unhealthy_hosts.aggregation
    operator         = "GreaterThanOrEqual"
    threshold        = local.resolved.unhealthy_hosts.warning_threshold
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

resource "azurerm_monitor_metric_alert" "unhealthy_hosts_crit" {
  count = local.resolved.unhealthy_hosts.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-unhealthy-hosts-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.unhealthy_hosts.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.unhealthy_hosts.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.unhealthy_hosts.name
    aggregation      = local.metrics.unhealthy_hosts.aggregation
    operator         = "GreaterThanOrEqual"
    threshold        = local.resolved.unhealthy_hosts.critical_threshold
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

# Backend 5xx Alerts (with dimension filter)
resource "azurerm_monitor_metric_alert" "backend_5xx_warn" {
  count = local.resolved.backend_5xx.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-backend-5xx-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.backend_5xx.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.backend_5xx.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.backend_5xx.name
    aggregation      = local.metrics.backend_5xx.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.backend_5xx.warning_threshold

    dimension {
      name     = local.metrics.backend_5xx.dimension.name
      operator = local.metrics.backend_5xx.dimension.operator
      values   = local.metrics.backend_5xx.dimension.values
    }
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

resource "azurerm_monitor_metric_alert" "backend_5xx_crit" {
  count = local.resolved.backend_5xx.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-backend-5xx-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.backend_5xx.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.backend_5xx.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.backend_5xx.name
    aggregation      = local.metrics.backend_5xx.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.backend_5xx.critical_threshold

    dimension {
      name     = local.metrics.backend_5xx.dimension.name
      operator = local.metrics.backend_5xx.dimension.operator
      values   = local.metrics.backend_5xx.dimension.values
    }
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

# CPU Alerts
resource "azurerm_monitor_metric_alert" "cpu_warn" {
  count = local.resolved.cpu.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-cpu-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.cpu.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.cpu.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.cpu.name
    aggregation      = local.metrics.cpu.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.cpu.warning_threshold
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

resource "azurerm_monitor_metric_alert" "cpu_crit" {
  count = local.resolved.cpu.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-cpu-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.cpu.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.cpu.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.cpu.name
    aggregation      = local.metrics.cpu.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.cpu.critical_threshold
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

# Capacity Units Alerts
resource "azurerm_monitor_metric_alert" "capacity_units_warn" {
  count = local.resolved.capacity_units.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-capacity-units-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.capacity_units.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.capacity_units.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.capacity_units.name
    aggregation      = local.metrics.capacity_units.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.capacity_units.warning_threshold
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

resource "azurerm_monitor_metric_alert" "capacity_units_crit" {
  count = local.resolved.capacity_units.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-capacity-units-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.capacity_units.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.capacity_units.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.capacity_units.name
    aggregation      = local.metrics.capacity_units.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.capacity_units.critical_threshold
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

# Failed Requests Alerts
resource "azurerm_monitor_metric_alert" "failed_requests_warn" {
  count = local.resolved.failed_requests.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-failed-requests-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.failed_requests.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.failed_requests.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.failed_requests.name
    aggregation      = local.metrics.failed_requests.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.failed_requests.warning_threshold
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

resource "azurerm_monitor_metric_alert" "failed_requests_crit" {
  count = local.resolved.failed_requests.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-failed-requests-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.failed_requests.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.failed_requests.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.failed_requests.name
    aggregation      = local.metrics.failed_requests.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.failed_requests.critical_threshold
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

# Response 5xx Alerts (with dimension filter)
resource "azurerm_monitor_metric_alert" "response_5xx_warn" {
  count = local.resolved.response_5xx.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-response-5xx-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.response_5xx.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.response_5xx.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.response_5xx.name
    aggregation      = local.metrics.response_5xx.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.response_5xx.warning_threshold

    dimension {
      name     = local.metrics.response_5xx.dimension.name
      operator = local.metrics.response_5xx.dimension.operator
      values   = local.metrics.response_5xx.dimension.values
    }
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

resource "azurerm_monitor_metric_alert" "response_5xx_crit" {
  count = local.resolved.response_5xx.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-response-5xx-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.response_5xx.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.response_5xx.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.response_5xx.name
    aggregation      = local.metrics.response_5xx.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.response_5xx.critical_threshold

    dimension {
      name     = local.metrics.response_5xx.dimension.name
      operator = local.metrics.response_5xx.dimension.operator
      values   = local.metrics.response_5xx.dimension.values
    }
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
