locals {
  profiles = {
    standard = {
      http_5xx = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 20
        window_minutes     = 5
      }
      http_4xx = {
        enabled            = false # Often noisy, enable if needed
        warning_threshold  = 50
        critical_threshold = 200
        window_minutes     = 5
      }
      response_time = {
        enabled            = true
        warning_threshold  = 5 # seconds
        critical_threshold = 10
        window_minutes     = 5
      }
      memory = {
        enabled            = true
        warning_threshold  = 80 # percentage of limit
        critical_threshold = 95
        window_minutes     = 5
      }
      execution_count = {
        enabled            = false # Disabled by default, enable for baseline
        warning_threshold  = 10000
        critical_threshold = 50000
        window_minutes     = 5
      }
    }

    critical = {
      http_5xx = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 10
        window_minutes     = 5
      }
      http_4xx = {
        enabled            = false
        warning_threshold  = 25
        critical_threshold = 100
        window_minutes     = 5
      }
      response_time = {
        enabled            = true
        warning_threshold  = 2
        critical_threshold = 5
        window_minutes     = 5
      }
      memory = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      execution_count = {
        enabled            = false
        warning_threshold  = 10000
        critical_threshold = 50000
        window_minutes     = 5
      }
    }
  }
}
