locals {
  # Profile definitions based on implementation guide
  # Replication lag is disabled by default (only applicable for read replicas)
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
      connections = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 90
        window_minutes     = 5
      }
      failed_connections = {
        enabled            = true
        warning_threshold  = 10
        critical_threshold = 50
        window_minutes     = 5
      }
      availability = {
        enabled            = true
        critical_threshold = 1
        window_minutes     = 1
      }
      replication_lag = {
        enabled            = false  # Only for read replicas
        warning_threshold  = 30
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
      connections = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 85
        window_minutes     = 5
      }
      failed_connections = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 25
        window_minutes     = 5
      }
      availability = {
        enabled            = true
        critical_threshold = 1
        window_minutes     = 1
      }
      replication_lag = {
        enabled            = false  # Only for read replicas
        warning_threshold  = 10
        critical_threshold = 30
        window_minutes     = 5
      }
    }
  }

  # Select the active profile
  active_profile = local.profiles[var.profile]
}
