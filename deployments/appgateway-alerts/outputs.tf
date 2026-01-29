output "alert_ids" {
  description = "Map of created alert rule IDs"
  value       = module.appgateway_alerts.alert_ids
}

output "alert_names" {
  description = "Map of created alert rule names"
  value       = module.appgateway_alerts.alert_names
}

output "profile" {
  description = "The alert profile used"
  value       = module.appgateway_alerts.profile
}
