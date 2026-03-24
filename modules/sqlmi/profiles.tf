locals {
  profiles = {
    standard = {
      cpu = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      storage = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 90
        window_minutes     = 15
      }
      io_requests = {
        enabled            = true
        warning_threshold  = 80 # percentage of IOPS limit
        critical_threshold = 95
        window_minutes     = 5
      }
      io_bytes = {
        enabled            = true
        warning_threshold  = 80 # percentage of throughput limit
        critical_threshold = 95
        window_minutes     = 5
      }
    }

    critical = {
      cpu = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      storage = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 85
        window_minutes     = 15
      }
      io_requests = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      io_bytes = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
    }
  }
}
