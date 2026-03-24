locals {
  profiles = {
    standard = {
      tunnel_status = {
        enabled            = true
        critical_threshold = 1 # Alert when tunnel is down
        window_minutes     = 1
      }
      tunnel_bandwidth = {
        enabled            = true
        warning_threshold  = 80 # % of SKU limit
        critical_threshold = 95
        window_minutes     = 5
      }
      p2s_bandwidth = {
        enabled            = false # Disabled by default - enable for P2S VPN
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      p2s_connection_count = {
        enabled            = false # Disabled by default - enable for P2S VPN
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      tunnel_drop_count = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 20
        window_minutes     = 5
      }
    }

    critical = {
      tunnel_status = {
        enabled            = true
        critical_threshold = 1
        window_minutes     = 1
      }
      tunnel_bandwidth = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      p2s_bandwidth = {
        enabled            = false
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      p2s_connection_count = {
        enabled            = false
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      tunnel_drop_count = {
        enabled            = true
        warning_threshold  = 2
        critical_threshold = 10
        window_minutes     = 5
      }
    }
  }
}
