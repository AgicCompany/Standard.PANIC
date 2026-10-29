locals {
  profiles = {
    standard = {
      health_state = {
        enabled            = true
        warning_threshold  = 99
        critical_threshold = 95
        window_minutes     = 1
      }
      throughput = {
        enabled            = false # enable with raw bits/sec thresholds via overrides
        warning_threshold  = 80    # Placeholder bits/sec, not a recommended limit
        critical_threshold = 95
        window_minutes     = 5
      }
      snat_port_utilization = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      latency = {
        enabled            = true
        warning_threshold  = 20 # milliseconds
        critical_threshold = 50
        window_minutes     = 5
      }
    }

    critical = {
      health_state = {
        enabled            = true
        warning_threshold  = 99.5
        critical_threshold = 99
        window_minutes     = 1
      }
      throughput = {
        enabled            = false # enable with raw bits/sec thresholds via overrides
        warning_threshold  = 70    # Placeholder bits/sec, not a recommended limit
        critical_threshold = 90
        window_minutes     = 5
      }
      snat_port_utilization = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      latency = {
        enabled            = true
        warning_threshold  = 10
        critical_threshold = 30
        window_minutes     = 5
      }
    }
  }
}
