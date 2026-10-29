locals {
  metric_namespace = "Microsoft.Compute/disks"

  metrics = {
    iops_consumed = {
      name        = "Composite Disk Read Operations/sec"
      aggregation = "Average"
      description = "Disk read operations per second"
      # Raw rate, not a percentage. For percentage-based monitoring use the VM-level
      # metrics (Data Disk IOPS Consumed Percentage) via the vm module
    }
    bandwidth_consumed = {
      name        = "Composite Disk Read Bytes/sec"
      aggregation = "Average"
      description = "Disk read bytes per second"
      # Raw rate, not a percentage. For percentage-based monitoring use the VM-level
      # metrics (Data Disk Bandwidth Consumed Percentage)
    }
    queue_depth = {
      name        = "DiskQueueDepth"
      aggregation = "Average"
      description = "Disk I/O queue depth (saturation indicator)"
      # Not a Microsoft.Compute/disks metric: enabling fails. Queue depth exists
      # only at VM level. The name is deliberately invalid so it can never
      # silently duplicate another alert.
    }
    burst_bps_credits = {
      name        = "BurstBPSCreditsPercent"
      aggregation = "Average"
      description = "Remaining burst bandwidth credits percentage"
      # Not a Microsoft.Compute/disks metric: enabling fails. VM level only.
    }
    burst_io_credits = {
      name        = "BurstIOCreditsPercent"
      aggregation = "Average"
      description = "Remaining burst IOPS credits percentage"
      # Not a Microsoft.Compute/disks metric: enabling fails. VM level only.
    }
  }

  # Resolve final values: override -> profile -> defaults
  selected_profile = local.profiles[var.profile]

  resolved = {
    iops_consumed = {
      enabled            = coalesce(try(var.overrides.iops_consumed.enabled, null), local.selected_profile.iops_consumed.enabled)
      warning_threshold  = coalesce(try(var.overrides.iops_consumed.warning_threshold, null), local.selected_profile.iops_consumed.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.iops_consumed.critical_threshold, null), local.selected_profile.iops_consumed.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.iops_consumed.window_minutes, null), local.selected_profile.iops_consumed.window_minutes)
    }
    bandwidth_consumed = {
      enabled            = coalesce(try(var.overrides.bandwidth_consumed.enabled, null), local.selected_profile.bandwidth_consumed.enabled)
      warning_threshold  = coalesce(try(var.overrides.bandwidth_consumed.warning_threshold, null), local.selected_profile.bandwidth_consumed.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.bandwidth_consumed.critical_threshold, null), local.selected_profile.bandwidth_consumed.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.bandwidth_consumed.window_minutes, null), local.selected_profile.bandwidth_consumed.window_minutes)
    }
    queue_depth = {
      enabled            = coalesce(try(var.overrides.queue_depth.enabled, null), local.selected_profile.queue_depth.enabled)
      warning_threshold  = coalesce(try(var.overrides.queue_depth.warning_threshold, null), local.selected_profile.queue_depth.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.queue_depth.critical_threshold, null), local.selected_profile.queue_depth.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.queue_depth.window_minutes, null), local.selected_profile.queue_depth.window_minutes)
    }
    burst_bps_credits = {
      enabled            = coalesce(try(var.overrides.burst_bps_credits.enabled, null), local.selected_profile.burst_bps_credits.enabled)
      warning_threshold  = coalesce(try(var.overrides.burst_bps_credits.warning_threshold, null), local.selected_profile.burst_bps_credits.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.burst_bps_credits.critical_threshold, null), local.selected_profile.burst_bps_credits.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.burst_bps_credits.window_minutes, null), local.selected_profile.burst_bps_credits.window_minutes)
    }
    burst_io_credits = {
      enabled            = coalesce(try(var.overrides.burst_io_credits.enabled, null), local.selected_profile.burst_io_credits.enabled)
      warning_threshold  = coalesce(try(var.overrides.burst_io_credits.warning_threshold, null), local.selected_profile.burst_io_credits.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.burst_io_credits.critical_threshold, null), local.selected_profile.burst_io_credits.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.burst_io_credits.window_minutes, null), local.selected_profile.burst_io_credits.window_minutes)
    }
  }

  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
