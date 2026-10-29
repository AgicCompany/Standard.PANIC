locals {
  profiles = {
    standard = {
      tunnel_status = {
        enabled            = false # No tunnel state metric exists; enabling alerts on idle tunnels
        critical_threshold = 1     # Inbound packet count
        window_minutes     = 1
      }
      tunnel_bandwidth = {
        enabled            = false # enable with raw Bytes/sec thresholds via overrides
        warning_threshold  = 80    # Placeholder Bytes/sec, not a recommended limit
        critical_threshold = 95
        window_minutes     = 5
      }
      p2s_bandwidth = {
        enabled            = false # enable with raw Bytes/sec thresholds via overrides for P2S VPN
        warning_threshold  = 80    # Placeholder Bytes/sec
        critical_threshold = 95
        window_minutes     = 5
      }
      p2s_connection_count = {
        enabled            = false # enable with raw count thresholds via overrides for P2S VPN
        warning_threshold  = 80    # Placeholder count
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
        enabled            = false # No tunnel state metric exists; enabling alerts on idle tunnels
        critical_threshold = 1     # Inbound packet count
        window_minutes     = 1
      }
      tunnel_bandwidth = {
        enabled            = false # enable with raw Bytes/sec thresholds via overrides
        warning_threshold  = 70    # Placeholder Bytes/sec, not a recommended limit
        critical_threshold = 90
        window_minutes     = 5
      }
      p2s_bandwidth = {
        enabled            = false # enable with raw Bytes/sec thresholds via overrides for P2S VPN
        warning_threshold  = 70    # Placeholder Bytes/sec
        critical_threshold = 90
        window_minutes     = 5
      }
      p2s_connection_count = {
        enabled            = false # enable with raw count thresholds via overrides for P2S VPN
        warning_threshold  = 70    # Placeholder count
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
