locals {
  # Thresholds per profile. All metrics are platform metrics; no agent needed.
  # memory and availability use LessThan: lower values are worse.
  profiles = {
    standard = {
      cpu = {
        enabled            = true
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      memory = {
        enabled            = true
        warning_threshold  = 15
        critical_threshold = 10
        window_minutes     = 5
      }
      os_disk_iops = {
        enabled            = true
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      data_disk_iops = {
        enabled            = true
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      availability = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 0.5
        window_minutes     = 5
      }
    }
    critical = {
      cpu = {
        enabled            = true
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      memory = {
        enabled            = true
        warning_threshold  = 20
        critical_threshold = 15
        window_minutes     = 5
      }
      os_disk_iops = {
        enabled            = true
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      data_disk_iops = {
        enabled            = true
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      availability = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 0.75
        window_minutes     = 5
      }
    }
  }
}
