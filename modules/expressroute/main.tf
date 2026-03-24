# BGP Availability Alerts
resource "azurerm_monitor_metric_alert" "bgp_availability_warn" {
  count = local.resolved.bgp_availability.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-bgp-avail-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.bgp_availability.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.bgp_availability.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.bgp_availability.name
    aggregation      = local.metrics.bgp_availability.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.bgp_availability.warning_threshold
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

resource "azurerm_monitor_metric_alert" "bgp_availability_crit" {
  count = local.resolved.bgp_availability.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-bgp-avail-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.bgp_availability.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.bgp_availability.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.bgp_availability.name
    aggregation      = local.metrics.bgp_availability.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.bgp_availability.critical_threshold
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

# ARP Availability Alerts
resource "azurerm_monitor_metric_alert" "arp_availability_warn" {
  count = local.resolved.arp_availability.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-arp-avail-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.arp_availability.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.arp_availability.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.arp_availability.name
    aggregation      = local.metrics.arp_availability.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.arp_availability.warning_threshold
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

resource "azurerm_monitor_metric_alert" "arp_availability_crit" {
  count = local.resolved.arp_availability.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-arp-avail-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.arp_availability.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.arp_availability.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.arp_availability.name
    aggregation      = local.metrics.arp_availability.aggregation
    operator         = "LessThan"
    threshold        = local.resolved.arp_availability.critical_threshold
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

# Bits In Per Second Alerts
resource "azurerm_monitor_metric_alert" "bits_in_warn" {
  count = local.resolved.bits_in.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-bits-in-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.bits_in.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.bits_in.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.bits_in.name
    aggregation      = local.metrics.bits_in.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.bits_in.warning_threshold
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

resource "azurerm_monitor_metric_alert" "bits_in_crit" {
  count = local.resolved.bits_in.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-bits-in-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.bits_in.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.bits_in.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.bits_in.name
    aggregation      = local.metrics.bits_in.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.bits_in.critical_threshold
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

# Bits Out Per Second Alerts
resource "azurerm_monitor_metric_alert" "bits_out_warn" {
  count = local.resolved.bits_out.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-bits-out-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.bits_out.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.bits_out.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.bits_out.name
    aggregation      = local.metrics.bits_out.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.bits_out.warning_threshold
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

resource "azurerm_monitor_metric_alert" "bits_out_crit" {
  count = local.resolved.bits_out.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-bits-out-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.bits_out.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.bits_out.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.bits_out.name
    aggregation      = local.metrics.bits_out.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.bits_out.critical_threshold
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

# Dropped Packets In Alerts
resource "azurerm_monitor_metric_alert" "dropped_packets_in_warn" {
  count = local.resolved.dropped_packets_in.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-drops-in-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.dropped_packets_in.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.dropped_packets_in.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.dropped_packets_in.name
    aggregation      = local.metrics.dropped_packets_in.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.dropped_packets_in.warning_threshold
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

resource "azurerm_monitor_metric_alert" "dropped_packets_in_crit" {
  count = local.resolved.dropped_packets_in.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-drops-in-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.dropped_packets_in.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.dropped_packets_in.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.dropped_packets_in.name
    aggregation      = local.metrics.dropped_packets_in.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.dropped_packets_in.critical_threshold
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

# Dropped Packets Out Alerts
resource "azurerm_monitor_metric_alert" "dropped_packets_out_warn" {
  count = local.resolved.dropped_packets_out.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-drops-out-warn"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Warning: ${local.metrics.dropped_packets_out.description}"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.dropped_packets_out.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.dropped_packets_out.name
    aggregation      = local.metrics.dropped_packets_out.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.dropped_packets_out.warning_threshold
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

resource "azurerm_monitor_metric_alert" "dropped_packets_out_crit" {
  count = local.resolved.dropped_packets_out.enabled && var.enabled ? 1 : 0

  name                = "${var.resource_name}-drops-out-crit"
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_id]
  description         = "Critical: ${local.metrics.dropped_packets_out.description}"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT${local.resolved.dropped_packets_out.window_minutes}M"
  auto_mitigate       = true

  criteria {
    metric_namespace = local.metric_namespace
    metric_name      = local.metrics.dropped_packets_out.name
    aggregation      = local.metrics.dropped_packets_out.aggregation
    operator         = "GreaterThan"
    threshold        = local.resolved.dropped_packets_out.critical_threshold
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
