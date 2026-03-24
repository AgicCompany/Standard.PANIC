output "alert_ids" {
  description = "Map of created alert rule IDs"
  value = {
    bgp_availability_warn    = try(azurerm_monitor_metric_alert.bgp_availability_warn[0].id, null)
    bgp_availability_crit    = try(azurerm_monitor_metric_alert.bgp_availability_crit[0].id, null)
    arp_availability_warn    = try(azurerm_monitor_metric_alert.arp_availability_warn[0].id, null)
    arp_availability_crit    = try(azurerm_monitor_metric_alert.arp_availability_crit[0].id, null)
    bits_in_warn             = try(azurerm_monitor_metric_alert.bits_in_warn[0].id, null)
    bits_in_crit             = try(azurerm_monitor_metric_alert.bits_in_crit[0].id, null)
    bits_out_warn            = try(azurerm_monitor_metric_alert.bits_out_warn[0].id, null)
    bits_out_crit            = try(azurerm_monitor_metric_alert.bits_out_crit[0].id, null)
    dropped_packets_in_warn  = try(azurerm_monitor_metric_alert.dropped_packets_in_warn[0].id, null)
    dropped_packets_in_crit  = try(azurerm_monitor_metric_alert.dropped_packets_in_crit[0].id, null)
    dropped_packets_out_warn = try(azurerm_monitor_metric_alert.dropped_packets_out_warn[0].id, null)
    dropped_packets_out_crit = try(azurerm_monitor_metric_alert.dropped_packets_out_crit[0].id, null)
  }
}

output "alert_names" {
  description = "Map of created alert rule names"
  value = {
    bgp_availability_warn    = try(azurerm_monitor_metric_alert.bgp_availability_warn[0].name, null)
    bgp_availability_crit    = try(azurerm_monitor_metric_alert.bgp_availability_crit[0].name, null)
    arp_availability_warn    = try(azurerm_monitor_metric_alert.arp_availability_warn[0].name, null)
    arp_availability_crit    = try(azurerm_monitor_metric_alert.arp_availability_crit[0].name, null)
    bits_in_warn             = try(azurerm_monitor_metric_alert.bits_in_warn[0].name, null)
    bits_in_crit             = try(azurerm_monitor_metric_alert.bits_in_crit[0].name, null)
    bits_out_warn            = try(azurerm_monitor_metric_alert.bits_out_warn[0].name, null)
    bits_out_crit            = try(azurerm_monitor_metric_alert.bits_out_crit[0].name, null)
    dropped_packets_in_warn  = try(azurerm_monitor_metric_alert.dropped_packets_in_warn[0].name, null)
    dropped_packets_in_crit  = try(azurerm_monitor_metric_alert.dropped_packets_in_crit[0].name, null)
    dropped_packets_out_warn = try(azurerm_monitor_metric_alert.dropped_packets_out_warn[0].name, null)
    dropped_packets_out_crit = try(azurerm_monitor_metric_alert.dropped_packets_out_crit[0].name, null)
  }
}

output "profile" {
  description = "The alert profile used"
  value       = var.profile
}

output "resolved_thresholds" {
  description = "Final threshold values after applying overrides"
  value       = local.resolved
}
