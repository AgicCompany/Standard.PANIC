locals {
  profiles = {
    standard = {
      iops_consumed = {
        enabled            = false # Raw read ops/sec: enable with thresholds sized to the disk IOPS limit
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      bandwidth_consumed = {
        enabled            = false # Raw read bytes/sec: enable with thresholds sized to the disk throughput limit
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      queue_depth = {
        enabled            = false # Not available on Microsoft.Compute/disks, see README
        warning_threshold  = 32
        critical_threshold = 64
        window_minutes     = 5
      }
      burst_bps_credits = {
        enabled            = false # Not available on Microsoft.Compute/disks, see README
        warning_threshold  = 20    # Lower is worse - alert when credits drop below
        critical_threshold = 10
        window_minutes     = 5
      }
      burst_io_credits = {
        enabled            = false # Not available on Microsoft.Compute/disks, see README
        warning_threshold  = 20    # Lower is worse - alert when credits drop below
        critical_threshold = 10
        window_minutes     = 5
      }
    }

    critical = {
      iops_consumed = {
        enabled            = false # Raw read ops/sec: enable with thresholds sized to the disk IOPS limit
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      bandwidth_consumed = {
        enabled            = false # Raw read bytes/sec: enable with thresholds sized to the disk throughput limit
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      queue_depth = {
        enabled            = false # Not available on Microsoft.Compute/disks, see README
        warning_threshold  = 16
        critical_threshold = 32
        window_minutes     = 5
      }
      burst_bps_credits = {
        enabled            = false # Not available on Microsoft.Compute/disks, see README
        warning_threshold  = 30    # Lower is worse - alert when credits drop below
        critical_threshold = 20
        window_minutes     = 5
      }
      burst_io_credits = {
        enabled            = false # Not available on Microsoft.Compute/disks, see README
        warning_threshold  = 30    # Lower is worse - alert when credits drop below
        critical_threshold = 20
        window_minutes     = 5
      }
    }
  }
}
