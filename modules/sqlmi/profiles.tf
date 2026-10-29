locals {
  profiles = {
    standard = {
      cpu = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      storage = {
        enabled            = false # Raw MB metric: enable and set thresholds from reserved storage
        warning_threshold  = 80
        critical_threshold = 90
        window_minutes     = 15
      }
      io_requests = {
        enabled            = false # enable with raw count thresholds via overrides
        warning_threshold  = 80    # Placeholder count, not a recommended limit
        critical_threshold = 95
        window_minutes     = 5
      }
      io_bytes = {
        enabled            = false # enable with raw byte thresholds via overrides
        warning_threshold  = 80    # Placeholder bytes, not a recommended limit
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
      storage = {
        enabled            = false # Raw MB metric: enable and set thresholds from reserved storage
        warning_threshold  = 70
        critical_threshold = 85
        window_minutes     = 15
      }
      io_requests = {
        enabled            = false # enable with raw count thresholds via overrides
        warning_threshold  = 70    # Placeholder count, not a recommended limit
        critical_threshold = 90
        window_minutes     = 5
      }
      io_bytes = {
        enabled            = false # enable with raw byte thresholds via overrides
        warning_threshold  = 70    # Placeholder bytes, not a recommended limit
        critical_threshold = 90
        window_minutes     = 5
      }
    }
  }
}
