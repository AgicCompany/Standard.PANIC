locals {
  # Default alert settings
  defaults = {
    frequency_minutes = 1
    auto_mitigate     = true
    severity_warning  = 2
    severity_critical = 1
  }

  # Metric definitions for Virtual Machines
  # Platform metrics are from Microsoft.Compute/virtualMachines namespace
  # Guest metrics require Azure Monitor Agent and Data Collection Rules
  metrics = {
    cpu = {
      namespace   = "Microsoft.Compute/virtualMachines"
      name        = "Percentage CPU"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "VM CPU utilization percentage"
    }
    memory = {
      # Guest metric - requires Azure Monitor Agent
      # Uses Available MBytes Memory from guest OS
      namespace   = "Microsoft.Compute/virtualMachines"
      name        = "Available Memory Bytes"
      aggregation = "Average"
      operator    = "LessThan"
      description = "VM available memory percentage (requires AMA)"
    }
    os_disk_iops = {
      namespace   = "Microsoft.Compute/virtualMachines"
      name        = "OS Disk IOPS Consumed Percentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "OS disk IOPS consumed percentage"
    }
    data_disk_iops = {
      namespace   = "Microsoft.Compute/virtualMachines"
      name        = "Data Disk IOPS Consumed Percentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Data disk IOPS consumed percentage"
    }
    disk_free = {
      # Guest metric - requires Azure Monitor Agent
      namespace   = "Microsoft.Compute/virtualMachines"
      name        = "Logical Disk Free Space Percentage"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Logical disk free space percentage (requires AMA)"
    }
    availability = {
      namespace   = "Microsoft.Compute/virtualMachines"
      name        = "VmAvailabilityMetric"
      aggregation = "Average"
      operator    = "LessThan"
      description = "VM availability status (1 = available, 0 = unavailable)"
    }
  }

  # Resolve final values: override -> profile -> defaults
  resolved = {
    cpu = {
      enabled            = try(var.overrides.cpu.enabled, local.active_profile.cpu.enabled)
      warning_threshold  = try(var.overrides.cpu.warning_threshold, local.active_profile.cpu.warning_threshold)
      critical_threshold = try(var.overrides.cpu.critical_threshold, local.active_profile.cpu.critical_threshold)
      window_minutes     = try(var.overrides.cpu.window_minutes, local.active_profile.cpu.window_minutes)
    }
    memory = {
      enabled            = try(var.overrides.memory.enabled, local.active_profile.memory.enabled)
      warning_threshold  = try(var.overrides.memory.warning_threshold, local.active_profile.memory.warning_threshold)
      critical_threshold = try(var.overrides.memory.critical_threshold, local.active_profile.memory.critical_threshold)
      window_minutes     = try(var.overrides.memory.window_minutes, local.active_profile.memory.window_minutes)
    }
    os_disk_iops = {
      enabled            = try(var.overrides.os_disk_iops.enabled, local.active_profile.os_disk_iops.enabled)
      warning_threshold  = try(var.overrides.os_disk_iops.warning_threshold, local.active_profile.os_disk_iops.warning_threshold)
      critical_threshold = try(var.overrides.os_disk_iops.critical_threshold, local.active_profile.os_disk_iops.critical_threshold)
      window_minutes     = try(var.overrides.os_disk_iops.window_minutes, local.active_profile.os_disk_iops.window_minutes)
    }
    data_disk_iops = {
      enabled            = try(var.overrides.data_disk_iops.enabled, local.active_profile.data_disk_iops.enabled)
      warning_threshold  = try(var.overrides.data_disk_iops.warning_threshold, local.active_profile.data_disk_iops.warning_threshold)
      critical_threshold = try(var.overrides.data_disk_iops.critical_threshold, local.active_profile.data_disk_iops.critical_threshold)
      window_minutes     = try(var.overrides.data_disk_iops.window_minutes, local.active_profile.data_disk_iops.window_minutes)
    }
    disk_free = {
      enabled            = try(var.overrides.disk_free.enabled, local.active_profile.disk_free.enabled)
      warning_threshold  = try(var.overrides.disk_free.warning_threshold, local.active_profile.disk_free.warning_threshold)
      critical_threshold = try(var.overrides.disk_free.critical_threshold, local.active_profile.disk_free.critical_threshold)
      window_minutes     = try(var.overrides.disk_free.window_minutes, local.active_profile.disk_free.window_minutes)
    }
    availability = {
      enabled            = try(var.overrides.availability.enabled, local.active_profile.availability.enabled)
      critical_threshold = try(var.overrides.availability.critical_threshold, local.active_profile.availability.critical_threshold)
      window_minutes     = try(var.overrides.availability.window_minutes, local.active_profile.availability.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by     = "terraform"
    module-version = "1.0.0"
  })
}
