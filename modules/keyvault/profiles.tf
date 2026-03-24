locals {
  profiles = {
    standard = {
      availability = {
        enabled            = true
        warning_threshold  = 99
        critical_threshold = 95
        window_minutes     = 5
      }
      latency = {
        enabled            = true
        warning_threshold  = 500 # milliseconds
        critical_threshold = 1000
        window_minutes     = 5
      }
      saturation = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 15
      }
      api_hits = {
        enabled            = false # Disabled by default, enable for baseline
        warning_threshold  = 10000
        critical_threshold = 50000
        window_minutes     = 5
      }
    }

    critical = {
      availability = {
        enabled            = true
        warning_threshold  = 99.9
        critical_threshold = 99
        window_minutes     = 5
      }
      latency = {
        enabled            = true
        warning_threshold  = 200
        critical_threshold = 500
        window_minutes     = 5
      }
      saturation = {
        enabled            = true
        warning_threshold  = 60
        critical_threshold = 80
        window_minutes     = 15
      }
      api_hits = {
        enabled            = false
        warning_threshold  = 10000
        critical_threshold = 50000
        window_minutes     = 5
      }
    }
  }
}
