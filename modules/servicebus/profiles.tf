locals {
  profiles = {
    standard = {
      active_messages = {
        enabled            = true
        warning_threshold  = 1000
        critical_threshold = 5000
        window_minutes     = 5
      }
      deadlettered_messages = {
        enabled            = true
        warning_threshold  = 10
        critical_threshold = 100
        window_minutes     = 5
      }
      throttled_requests = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 20
        window_minutes     = 5
      }
      server_errors = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 20
        window_minutes     = 5
      }
      size = {
        enabled            = true
        warning_threshold  = 80 # percentage of quota
        critical_threshold = 90
        window_minutes     = 15
      }
    }

    critical = {
      active_messages = {
        enabled            = true
        warning_threshold  = 500
        critical_threshold = 2000
        window_minutes     = 5
      }
      deadlettered_messages = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 50
        window_minutes     = 5
      }
      throttled_requests = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 10
        window_minutes     = 5
      }
      server_errors = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 10
        window_minutes     = 5
      }
      size = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 85
        window_minutes     = 15
      }
    }
  }
}
