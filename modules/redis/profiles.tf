locals {
  profiles = {
    standard = {
      server_load = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      memory = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      connected_clients = {
        enabled            = true
        warning_threshold  = 80 # percentage of max clients
        critical_threshold = 95
        window_minutes     = 5
      }
      cache_miss_rate = {
        enabled            = false # Enable based on workload expectations
        warning_threshold  = 50    # percentage
        critical_threshold = 80
        window_minutes     = 5
      }
      evicted_keys = {
        enabled            = true
        warning_threshold  = 100
        critical_threshold = 1000
        window_minutes     = 5
      }
    }

    critical = {
      server_load = {
        enabled            = true
        warning_threshold  = 60
        critical_threshold = 80
        window_minutes     = 5
      }
      memory = {
        enabled            = true
        warning_threshold  = 60
        critical_threshold = 80
        window_minutes     = 5
      }
      connected_clients = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      cache_miss_rate = {
        enabled            = false
        warning_threshold  = 30
        critical_threshold = 60
        window_minutes     = 5
      }
      evicted_keys = {
        enabled            = true
        warning_threshold  = 10
        critical_threshold = 100
        window_minutes     = 5
      }
    }
  }
}
