# Health Probe Status Alert (critical only - binary health check)
resource "azurerm_monitor_metric_alert" "health_probe_status_crit" {
  count = local.resolved.health_probe_status.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-health-probe-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.health_probe_status.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.health_probe_status.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.health_probe_status.name
    aggregation      = local.metrics.health_probe_status.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.health_probe_status.critical_threshold * 100 # Convert to percentage
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

# Data Path Availability Alerts
resource "azurerm_monitor_metric_alert" "data_path_availability_warn" {
  count = local.resolved.data_path_availability.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-data-path-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.data_path_availability.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.data_path_availability.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.data_path_availability.name
    aggregation      = local.metrics.data_path_availability.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.data_path_availability.warning_threshold
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

resource "azurerm_monitor_metric_alert" "data_path_availability_crit" {
  count = local.resolved.data_path_availability.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-data-path-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.data_path_availability.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.data_path_availability.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.data_path_availability.name
    aggregation      = local.metrics.data_path_availability.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.data_path_availability.critical_threshold
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

# SNAT Connection Count Alerts
resource "azurerm_monitor_metric_alert" "snat_connection_count_warn" {
  count = local.resolved.snat_connection_count.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-snat-conn-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.snat_connection_count.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.snat_connection_count.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.snat_connection_count.name
    aggregation      = local.metrics.snat_connection_count.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.snat_connection_count.warning_threshold
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

resource "azurerm_monitor_metric_alert" "snat_connection_count_crit" {
  count = local.resolved.snat_connection_count.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-snat-conn-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.snat_connection_count.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.snat_connection_count.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.snat_connection_count.name
    aggregation      = local.metrics.snat_connection_count.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.snat_connection_count.critical_threshold
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

# Used SNAT Ports Alerts
resource "azurerm_monitor_metric_alert" "used_snat_ports_warn" {
  count = local.resolved.used_snat_ports.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-snat-ports-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.used_snat_ports.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.used_snat_ports.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.used_snat_ports.name
    aggregation      = local.metrics.used_snat_ports.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.used_snat_ports.warning_threshold
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

resource "azurerm_monitor_metric_alert" "used_snat_ports_crit" {
  count = local.resolved.used_snat_ports.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-snat-ports-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.used_snat_ports.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.used_snat_ports.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.used_snat_ports.name
    aggregation      = local.metrics.used_snat_ports.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.used_snat_ports.critical_threshold
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
