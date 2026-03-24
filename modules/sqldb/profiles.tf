locals {
  profiles = {
    standard = {
      cpu = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      dtu = {
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
      deadlocks = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 20
        window_minutes     = 5
      }
      connection_failed = {
        enabled            = true
        warning_threshold  = 10
        critical_threshold = 50
        window_minutes     = 5
      }
      sessions = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      workers = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
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
      dtu = {
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
      deadlocks = {
        enabled            = true
        warning_threshold  = 2
        critical_threshold = 10
        window_minutes     = 5
      }
      connection_failed = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 25
        window_minutes     = 5
      }
      sessions = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      workers = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
    }
  }
}
