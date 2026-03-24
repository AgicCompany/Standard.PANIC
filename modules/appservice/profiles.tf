locals {
  # Profile definitions based on implementation guide
  # Note: CPU/Memory % metrics are at App Service Plan level, not app level
  # CpuTime (seconds) and AverageMemoryWorkingSet (bytes) are app-level but
  # thresholds are workload-dependent. Disabled by default.
  profiles = {
    standard = {
      cpu = {
        enabled            = false  # Requires plan-level monitoring
        warning_threshold  = 300    # CpuTime in seconds
        critical_threshold = 600
        window_minutes     = 5
      }
      memory = {
        enabled            = false  # Requires plan-level monitoring
        warning_threshold  = 1073741824   # 1GB in bytes
        critical_threshold = 1610612736   # 1.5GB in bytes
        window_minutes     = 5
      }
      http_5xx = {
        warning_threshold  = 10
        critical_threshold = 50
        window_minutes     = 5
      }
      response_time = {
        warning_threshold  = 2000
        critical_threshold = 5000
        window_minutes     = 5
      }
      health_check = {
        critical_threshold = 1
        window_minutes     = 5  # Minimum required by Azure
      }
    }
    critical = {
      cpu = {
        enabled            = false  # Requires plan-level monitoring
        warning_threshold  = 200
        critical_threshold = 400
        window_minutes     = 5
      }
      memory = {
        enabled            = false  # Requires plan-level monitoring
        warning_threshold  = 536870912    # 512MB in bytes
        critical_threshold = 1073741824   # 1GB in bytes
        window_minutes     = 5
      }
      http_5xx = {
        warning_threshold  = 5
        critical_threshold = 25
        window_minutes     = 5
      }
      response_time = {
        warning_threshold  = 1000
        critical_threshold = 3000
        window_minutes     = 5
      }
      health_check = {
        critical_threshold = 1
        window_minutes     = 5  # Minimum required by Azure
      }
    }
  }

  # Select the active profile
  active_profile = local.profiles[var.profile]
}
