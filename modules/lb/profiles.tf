locals {
  profiles = {
    standard = {
      health_probe_status = {
        enabled            = true
        critical_threshold = 1 # Alert when health probe status drops below 100%
        window_minutes     = 1
      }
      data_path_availability = {
        enabled            = true
        warning_threshold  = 99.9
        critical_threshold = 99
        window_minutes     = 1
      }
      snat_connection_count = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      used_snat_ports = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
    }

    critical = {
      health_probe_status = {
        enabled            = true
        critical_threshold = 1
        window_minutes     = 1
      }
      data_path_availability = {
        enabled            = true
        warning_threshold  = 99.95
        critical_threshold = 99.5
        window_minutes     = 1
      }
      snat_connection_count = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      used_snat_ports = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
    }
  }
}
