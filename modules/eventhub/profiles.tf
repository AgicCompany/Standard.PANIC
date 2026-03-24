locals {
  profiles = {
    standard = {
      throttled_requests = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 20
        window_minutes     = 5
      }
      quota_exceeded = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 10
        window_minutes     = 5
      }
      server_errors = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 20
        window_minutes     = 5
      }
      incoming_messages = {
        enabled            = false # Disabled by default, enable for baseline
        warning_threshold  = 100000
        critical_threshold = 500000
        window_minutes     = 5
      }
      capture_backlog = {
        enabled            = false # Enable if using Event Hubs Capture
        warning_threshold  = 1000
        critical_threshold = 10000
        window_minutes     = 5
      }
    }

    critical = {
      throttled_requests = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 10
        window_minutes     = 5
      }
      quota_exceeded = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 5
        window_minutes     = 5
      }
      server_errors = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 10
        window_minutes     = 5
      }
      incoming_messages = {
        enabled            = false
        warning_threshold  = 100000
        critical_threshold = 500000
        window_minutes     = 5
      }
      capture_backlog = {
        enabled            = false
        warning_threshold  = 500
        critical_threshold = 5000
        window_minutes     = 5
      }
    }
  }
}
