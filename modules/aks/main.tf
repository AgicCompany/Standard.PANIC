# Node CPU Usage Alerts
resource "azurerm_monitor_metric_alert" "node_cpu_warn" {
  count = var.enabled && local.resolved.node_cpu.enabled ? 1 : 0

  name                = "${var.resource_name}-nodecpu-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.node_cpu.description} exceeded ${local.resolved.node_cpu.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.node_cpu.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.node_cpu.name
    aggregation      = local.metrics.node_cpu.aggregation
    operator         = local.metrics.node_cpu.operator
    threshold        = local.resolved.node_cpu.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "node_cpu_crit" {
  count = var.enabled && local.resolved.node_cpu.enabled ? 1 : 0

  name                = "${var.resource_name}-nodecpu-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.node_cpu.description} exceeded ${local.resolved.node_cpu.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.node_cpu.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.node_cpu.name
    aggregation      = local.metrics.node_cpu.aggregation
    operator         = local.metrics.node_cpu.operator
    threshold        = local.resolved.node_cpu.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Node Memory Usage Alerts
resource "azurerm_monitor_metric_alert" "node_memory_warn" {
  count = var.enabled && local.resolved.node_memory.enabled ? 1 : 0

  name                = "${var.resource_name}-nodememory-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.node_memory.description} exceeded ${local.resolved.node_memory.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.node_memory.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.node_memory.name
    aggregation      = local.metrics.node_memory.aggregation
    operator         = local.metrics.node_memory.operator
    threshold        = local.resolved.node_memory.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "node_memory_crit" {
  count = var.enabled && local.resolved.node_memory.enabled ? 1 : 0

  name                = "${var.resource_name}-nodememory-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.node_memory.description} exceeded ${local.resolved.node_memory.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.node_memory.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.node_memory.name
    aggregation      = local.metrics.node_memory.aggregation
    operator         = local.metrics.node_memory.operator
    threshold        = local.resolved.node_memory.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Node Disk Usage Alerts
resource "azurerm_monitor_metric_alert" "node_disk_warn" {
  count = var.enabled && local.resolved.node_disk.enabled ? 1 : 0

  name                = "${var.resource_name}-nodedisk-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.node_disk.description} exceeded ${local.resolved.node_disk.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.node_disk.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.node_disk.name
    aggregation      = local.metrics.node_disk.aggregation
    operator         = local.metrics.node_disk.operator
    threshold        = local.resolved.node_disk.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "node_disk_crit" {
  count = var.enabled && local.resolved.node_disk.enabled ? 1 : 0

  name                = "${var.resource_name}-nodedisk-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.node_disk.description} exceeded ${local.resolved.node_disk.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.node_disk.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.node_disk.name
    aggregation      = local.metrics.node_disk.aggregation
    operator         = local.metrics.node_disk.operator
    threshold        = local.resolved.node_disk.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Pod Ready Status Alerts
resource "azurerm_monitor_metric_alert" "pod_ready_warn" {
  count = var.enabled && local.resolved.pod_ready.enabled ? 1 : 0

  name                = "${var.resource_name}-podready-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.pod_ready.description} below ${local.resolved.pod_ready.warning_threshold}%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.pod_ready.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.pod_ready.name
    aggregation      = local.metrics.pod_ready.aggregation
    operator         = local.metrics.pod_ready.operator
    threshold        = local.resolved.pod_ready.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "pod_ready_crit" {
  count = var.enabled && local.resolved.pod_ready.enabled ? 1 : 0

  name                = "${var.resource_name}-podready-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.pod_ready.description} below ${local.resolved.pod_ready.critical_threshold}%"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.pod_ready.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.pod_ready.name
    aggregation      = local.metrics.pod_ready.aggregation
    operator         = local.metrics.pod_ready.operator
    threshold        = local.resolved.pod_ready.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Node Count Alerts
resource "azurerm_monitor_metric_alert" "node_count_warn" {
  count = var.enabled && local.resolved.node_count.enabled ? 1 : 0

  name                = "${var.resource_name}-nodecount-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.node_count.description} below ${local.resolved.node_count.warning_threshold}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.node_count.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.node_count.name
    aggregation      = local.metrics.node_count.aggregation
    operator         = local.metrics.node_count.operator
    threshold        = local.resolved.node_count.warning_threshold

    dimension {
      name     = "status"
      operator = "Include"
      values   = ["Ready"]
    }
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "node_count_crit" {
  count = var.enabled && local.resolved.node_count.enabled ? 1 : 0

  name                = "${var.resource_name}-nodecount-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.node_count.description} below ${local.resolved.node_count.critical_threshold}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.node_count.window_minutes}M"
  auto_mitigate       = true
  enabled             = var.enabled

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.node_count.name
    aggregation      = local.metrics.node_count.aggregation
    operator         = local.metrics.node_count.operator
    threshold        = local.resolved.node_count.critical_threshold

    dimension {
      name     = "status"
      operator = "Include"
      values   = ["Ready"]
    }
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}
