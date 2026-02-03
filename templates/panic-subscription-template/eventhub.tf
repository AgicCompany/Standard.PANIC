module "event_hub_alerts" {
  source   = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-eventhub.git?ref=v1.0.0"
  for_each = var.enable_eventhub_alerts ? var.event_hubs : {}

  resource_id         = each.value.resource_id
  resource_name       = each.key
  resource_group_name = var.resource_group_name
  profile             = coalesce(each.value.profile, var.default_profile)
  action_group_ids    = var.action_group_ids
  overrides           = each.value.overrides

  tags = var.tags
}
