locals {
  metric_namespace = "Microsoft.Compute/disks"

  metrics = {
    iops_consumed = {
      name        = "Composite Disk Read Operations/sec"
      aggregation = "Average"
      description = "Disk IOPS consumed percentage"
      # Note: Uses combined read+write operations. For percentage-based monitoring,
      # consider using VM-level metrics (Data Disk IOPS Consumed Percentage)
    }
    bandwidth_consumed = {
      name        = "Composite Disk Read Bytes/sec"
      aggregation = "Average"
      description = "Disk bandwidth consumed percentage"
      # Note: Uses combined read+write bytes. For percentage-based monitoring,
      # consider using VM-level metrics (Data Disk Bandwidth Consumed Percentage)
    }
    queue_depth = {
      name        = "Composite Disk Read Operations/sec"
      aggregation = "Average"
      description = "Disk I/O queue depth (saturation indicator)"
      # Note: Queue depth metric may not be directly available on all disk types
    }
    burst_bps_credits = {
      name        = "BurstBPSCreditsPercent"
      aggregation = "Average"
      description = "Remaining burst bandwidth credits percentage"
    }
    burst_io_credits = {
      name        = "BurstIOCreditsPercent"
      aggregation = "Average"
      description = "Remaining burst IOPS credits percentage"
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
}
