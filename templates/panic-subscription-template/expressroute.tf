module "expressroute_circuit_alerts" {
  source   = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-expressroute.git?ref=v1.0.0"
  for_each = var.enable_expressroute_alerts ? var.expressroute_circuits : {}

  resource_id         = each.value.resource_id
  resource_name       = each.key
  resource_group_name = var.resource_group_name
  profile             = coalesce(each.value.profile, var.default_profile)
  action_group_ids    = var.action_group_ids
  overrides           = each.value.overrides

  tags = var.tags
}
