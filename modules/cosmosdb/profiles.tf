locals {
  profiles = {
    standard = {
      ru_consumption = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      availability = {
        enabled            = true
        warning_threshold  = 99.9
        critical_threshold = 99
        window_minutes     = 5
      }
      server_latency = {
        enabled            = true
        warning_threshold  = 50 # milliseconds
        critical_threshold = 100
        window_minutes     = 5
      }
      throttled_requests = {
        enabled            = true
        warning_threshold  = 10 # count per window
        critical_threshold = 50
        window_minutes     = 5
      }
      total_requests = {
        enabled            = false # Disabled by default, enable for baseline monitoring
        warning_threshold  = 10000
        critical_threshold = 50000
        window_minutes     = 5
      }
    }

    critical = {
      ru_consumption = {
        enabled            = true
        warning_threshold  = 60
        critical_threshold = 80
        window_minutes     = 5
      }
      availability = {
        enabled            = true
        warning_threshold  = 99.95
        critical_threshold = 99.5
        window_minutes     = 5
      }
      server_latency = {
        enabled            = true
        warning_threshold  = 30
        critical_threshold = 75
        window_minutes     = 5
      }
      throttled_requests = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 25
        window_minutes     = 5
      }
      total_requests = {
        enabled            = false
        warning_threshold  = 10000
        critical_threshold = 50000
        window_minutes     = 5
      }
    }
  }
}
