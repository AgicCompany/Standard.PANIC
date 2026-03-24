locals {
  profiles = {
    standard = {
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
      restarts = {
        enabled            = true
        warning_threshold  = 3
        critical_threshold = 10
        window_minutes     = 15
      }
      replicas = {
        enabled            = false # Enable and set based on expected min replicas
        warning_threshold  = 2
        critical_threshold = 1
        window_minutes     = 5
      }
      requests = {
        enabled            = false # Disabled by default, enable for baseline
        warning_threshold  = 10000
        critical_threshold = 50000
        window_minutes     = 5
      }
    }

    critical = {
      cpu = {
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
      restarts = {
        enabled            = true
        warning_threshold  = 1
        critical_threshold = 5
        window_minutes     = 15
      }
      replicas = {
        enabled            = false
        warning_threshold  = 3
        critical_threshold = 2
        window_minutes     = 5
      }
      requests = {
        enabled            = false
        warning_threshold  = 10000
        critical_threshold = 50000
        window_minutes     = 5
      }
    }
  }
}
