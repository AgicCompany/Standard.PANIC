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

# Memory - Warning Alert (Guest metric, requires AMA)
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

# Memory - Critical Alert (Guest metric, requires AMA)
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

# OS Disk IOPS - Warning Alert
resource "azurerm_monitor_metric_alert" "os_disk_iops_warn" {
  count = local.resolved.os_disk_iops.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-osdiskiops-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.os_disk_iops.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.os_disk_iops.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.os_disk_iops.namespace
    metric_name      = local.metrics.os_disk_iops.name
    aggregation      = local.metrics.os_disk_iops.aggregation
    operator         = local.metrics.os_disk_iops.operator
    threshold        = local.resolved.os_disk_iops.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

# OS Disk IOPS - Critical Alert
resource "azurerm_monitor_metric_alert" "os_disk_iops_crit" {
  count = local.resolved.os_disk_iops.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-osdiskiops-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.os_disk_iops.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.os_disk_iops.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.os_disk_iops.namespace
    metric_name      = local.metrics.os_disk_iops.name
    aggregation      = local.metrics.os_disk_iops.aggregation
    operator         = local.metrics.os_disk_iops.operator
    threshold        = local.resolved.os_disk_iops.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Data Disk IOPS - Warning Alert
resource "azurerm_monitor_metric_alert" "data_disk_iops_warn" {
  count = local.resolved.data_disk_iops.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-datadiskiops-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.data_disk_iops.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.data_disk_iops.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.data_disk_iops.namespace
    metric_name      = local.metrics.data_disk_iops.name
    aggregation      = local.metrics.data_disk_iops.aggregation
    operator         = local.metrics.data_disk_iops.operator
    threshold        = local.resolved.data_disk_iops.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

# Data Disk IOPS - Critical Alert
resource "azurerm_monitor_metric_alert" "data_disk_iops_crit" {
  count = local.resolved.data_disk_iops.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-datadiskiops-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.data_disk_iops.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.data_disk_iops.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.data_disk_iops.namespace
    metric_name      = local.metrics.data_disk_iops.name
    aggregation      = local.metrics.data_disk_iops.aggregation
    operator         = local.metrics.data_disk_iops.operator
    threshold        = local.resolved.data_disk_iops.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# Disk Free - Warning Alert (Guest metric, requires AMA)
resource "azurerm_monitor_metric_alert" "disk_free_warn" {
  count = local.resolved.disk_free.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-diskfree-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.disk_free.description
  severity            = local.defaults.severity_warning
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.disk_free.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.disk_free.namespace
    metric_name      = local.metrics.disk_free.name
    aggregation      = local.metrics.disk_free.aggregation
    operator         = local.metrics.disk_free.operator
    threshold        = local.resolved.disk_free.warning_threshold
  }

  action {
    action_group_id = var.action_group_ids.warning
  }

  tags = local.common_tags
}

# Disk Free - Critical Alert (Guest metric, requires AMA)
resource "azurerm_monitor_metric_alert" "disk_free_crit" {
  count = local.resolved.disk_free.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-diskfree-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = local.metrics.disk_free.description
  severity            = local.defaults.severity_critical
  enabled             = var.enabled
  auto_mitigate       = local.defaults.auto_mitigate
  frequency           = "PT${local.defaults.frequency_minutes}M"
  window_size         = "PT${local.resolved.disk_free.window_minutes}M"

  criteria {
    metric_namespace = local.metrics.disk_free.namespace
    metric_name      = local.metrics.disk_free.name
    aggregation      = local.metrics.disk_free.aggregation
    operator         = local.metrics.disk_free.operator
    threshold        = local.resolved.disk_free.critical_threshold
  }

  action {
    action_group_id = var.action_group_ids.critical
  }

  tags = local.common_tags
}

# VM Availability - Critical Alert (no warning level for availability)
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
