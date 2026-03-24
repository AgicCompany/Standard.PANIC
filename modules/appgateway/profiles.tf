locals {
  profiles = {
    standard = {
      unhealthy_hosts = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 2
        window_minutes     = 5
      }
      backend_5xx = {
        enabled            = true
        warning_threshold  = 10
        critical_threshold = 50
        window_minutes     = 5
      }
      cpu = {
        enabled            = false # CpuUtilization metric may not be available on all AppGW configurations
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      capacity_units = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      failed_requests = {
        enabled            = true
        warning_threshold  = 50
        critical_threshold = 200
        window_minutes     = 5
      }
      response_5xx = {
        enabled            = true
        warning_threshold  = 10
        critical_threshold = 50
        window_minutes     = 5
      }
    }

    critical = {
      unhealthy_hosts = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 1
        window_minutes     = 5
      }
      backend_5xx = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 25
        window_minutes     = 5
      }
      cpu = {
        enabled            = false # CpuUtilization metric may not be available on all AppGW configurations
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      capacity_units = {
        enabled            = true
        warning_threshold  = 60
        critical_threshold = 80
        window_minutes     = 5
      }
      failed_requests = {
        enabled            = true
        warning_threshold  = 25
        critical_threshold = 100
        window_minutes     = 5
      }
      response_5xx = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 25
        window_minutes     = 5
      }
    }
  }
}
