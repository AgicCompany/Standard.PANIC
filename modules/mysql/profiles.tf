locals {
  profiles = {
    standard = {
      cpu = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      memory = {
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
      io = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      connections = {
        enabled            = true
        warning_threshold  = 80 # percentage of max connections
        critical_threshold = 95
        window_minutes     = 5
      }
      aborted_connections = {
        enabled            = true
        warning_threshold  = 10
        critical_threshold = 50
        window_minutes     = 5
      }
      replication_lag = {
        enabled            = false # Enable for read replicas only
        warning_threshold  = 30    # seconds
        critical_threshold = 60
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
      memory = {
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
      io = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      connections = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      aborted_connections = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 25
        window_minutes     = 5
      }
      replication_lag = {
        enabled            = false
        warning_threshold  = 15
        critical_threshold = 30
        window_minutes     = 5
      }
    }
  }
}
