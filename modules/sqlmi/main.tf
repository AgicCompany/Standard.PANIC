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

# Storage Space Used Alerts (in MB - requires override for actual thresholds)
resource "azurerm_monitor_metric_alert" "storage_warn" {
  count = var.enabled && local.resolved.storage.enabled ? 1 : 0

  name                = "${var.resource_name}-storage-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.storage.description} exceeded threshold"
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
  description         = "Critical: ${local.metrics.storage.description} exceeded threshold"
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

# IO Requests Alerts
resource "azurerm_monitor_metric_alert" "io_requests_warn" {
  count = var.enabled && local.resolved.io_requests.enabled ? 1 : 0

  name                = "${var.resource_name}-iops-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.io_requests.description} exceeded threshold"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.io_requests.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.io_requests.name
    aggregation      = local.metrics.io_requests.aggregation
    operator         = local.metrics.io_requests.operator
    threshold        = local.resolved.io_requests.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "io_requests_crit" {
  count = var.enabled && local.resolved.io_requests.enabled ? 1 : 0

  name                = "${var.resource_name}-iops-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.io_requests.description} exceeded threshold"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.io_requests.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.io_requests.name
    aggregation      = local.metrics.io_requests.aggregation
    operator         = local.metrics.io_requests.operator
    threshold        = local.resolved.io_requests.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# IO Bytes Read Alerts
resource "azurerm_monitor_metric_alert" "io_bytes_warn" {
  count = var.enabled && local.resolved.io_bytes.enabled ? 1 : 0

  name                = "${var.resource_name}-iothroughput-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.io_bytes.description} exceeded threshold"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.io_bytes.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.io_bytes.name
    aggregation      = local.metrics.io_bytes.aggregation
    operator         = local.metrics.io_bytes.operator
    threshold        = local.resolved.io_bytes.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "io_bytes_crit" {
  count = var.enabled && local.resolved.io_bytes.enabled ? 1 : 0

  name                = "${var.resource_name}-iothroughput-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.io_bytes.description} exceeded threshold"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.io_bytes.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.io_bytes.name
    aggregation      = local.metrics.io_bytes.aggregation
    operator         = local.metrics.io_bytes.operator
    threshold        = local.resolved.io_bytes.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
