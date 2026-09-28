locals {
  # Metric namespace for Virtual Machine Scale Sets
  metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"

  # Metric definitions. No dimension filter: every alert evaluates the whole scale set.
  metrics = {
    cpu = {
      name        = "Percentage CPU"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Scale set CPU usage percentage"
    }
    memory = {
      name        = "Available Memory Percentage"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Scale set available memory percentage"
    }
    os_disk_iops = {
      name        = "OS Disk IOPS Consumed Percentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Scale set OS disk IOPS consumed percentage"
    }
    data_disk_iops = {
      name        = "Data Disk IOPS Consumed Percentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Scale set data disk IOPS consumed percentage"
    }
    availability = {
      name        = "VmAvailabilityMetric"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Scale set average VM availability (1 = all instances available)"
    }
  }

  # Select the profile
  selected_profile = local.profiles[var.profile]

  # Resolved configuration: override value if set, else profile value
  resolved = {
    cpu = {
      enabled            = coalesce(try(var.overrides.cpu.enabled, null), local.selected_profile.cpu.enabled)
      warning_threshold  = coalesce(try(var.overrides.cpu.warning_threshold, null), local.selected_profile.cpu.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.cpu.critical_threshold, null), local.selected_profile.cpu.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.cpu.window_minutes, null), local.selected_profile.cpu.window_minutes)
    }
    memory = {
      enabled            = coalesce(try(var.overrides.memory.enabled, null), local.selected_profile.memory.enabled)
      warning_threshold  = coalesce(try(var.overrides.memory.warning_threshold, null), local.selected_profile.memory.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.memory.critical_threshold, null), local.selected_profile.memory.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.memory.window_minutes, null), local.selected_profile.memory.window_minutes)
    }
    os_disk_iops = {
      enabled            = coalesce(try(var.overrides.os_disk_iops.enabled, null), local.selected_profile.os_disk_iops.enabled)
      warning_threshold  = coalesce(try(var.overrides.os_disk_iops.warning_threshold, null), local.selected_profile.os_disk_iops.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.os_disk_iops.critical_threshold, null), local.selected_profile.os_disk_iops.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.os_disk_iops.window_minutes, null), local.selected_profile.os_disk_iops.window_minutes)
    }
    data_disk_iops = {
      enabled            = coalesce(try(var.overrides.data_disk_iops.enabled, null), local.selected_profile.data_disk_iops.enabled)
      warning_threshold  = coalesce(try(var.overrides.data_disk_iops.warning_threshold, null), local.selected_profile.data_disk_iops.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.data_disk_iops.critical_threshold, null), local.selected_profile.data_disk_iops.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.data_disk_iops.window_minutes, null), local.selected_profile.data_disk_iops.window_minutes)
    }
    availability = {
      enabled            = coalesce(try(var.overrides.availability.enabled, null), local.selected_profile.availability.enabled)
      warning_threshold  = coalesce(try(var.overrides.availability.warning_threshold, null), local.selected_profile.availability.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.availability.critical_threshold, null), local.selected_profile.availability.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.availability.window_minutes, null), local.selected_profile.availability.window_minutes)
    }
  }

  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
