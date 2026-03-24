locals {
  # Profile definitions based on implementation guide
  profiles = {
    standard = {
      availability = {
        warning_threshold  = 99.9
        critical_threshold = 99
        window_minutes     = 5
      }
      latency = {
        warning_threshold  = 500
        critical_threshold = 1000
        window_minutes     = 5
      }
      throttling = {
        warning_threshold  = 10
        critical_threshold = 100
        window_minutes     = 5
      }
      used_capacity = {
        warning_threshold  = 80
        critical_threshold = 90
        window_minutes     = 60
      }
    }
    critical = {
      availability = {
        warning_threshold  = 99.95
        critical_threshold = 99.5
        window_minutes     = 5
      }
      latency = {
        warning_threshold  = 250
        critical_threshold = 500
        window_minutes     = 5
      }
      throttling = {
        warning_threshold  = 5
        critical_threshold = 50
        window_minutes     = 5
      }
      used_capacity = {
        warning_threshold  = 70
        critical_threshold = 85
        window_minutes     = 60
      }
    }
  }

  # Select the active profile
  active_profile = local.profiles[var.profile]
}
