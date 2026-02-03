module "sql_managed_instance_alerts" {
  source   = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-sqlmi.git?ref=v1.0.0"
  for_each = var.enable_sqlmi_alerts ? var.sql_managed_instances : {}

  resource_id         = each.value.resource_id
  resource_name       = each.key
  resource_group_name = var.resource_group_name
  profile             = coalesce(each.value.profile, var.default_profile)
  action_group_ids    = var.action_group_ids
  overrides           = each.value.overrides

  tags = var.tags
}
