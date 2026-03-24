locals {
  profiles = {
    standard = {
      bgp_availability = {
        enabled            = true
        warning_threshold  = 99.9
        critical_threshold = 99
        window_minutes     = 1
      }
      arp_availability = {
        enabled            = true
        warning_threshold  = 99.9
        critical_threshold = 99
        window_minutes     = 1
      }
      bits_in = {
        enabled            = true
        warning_threshold  = 80 # % of circuit bandwidth
        critical_threshold = 95
        window_minutes     = 5
      }
      bits_out = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      dropped_packets_in = {
        enabled            = true
        warning_threshold  = 10
        critical_threshold = 100
        window_minutes     = 5
      }
      dropped_packets_out = {
        enabled            = true
        warning_threshold  = 10
        critical_threshold = 100
        window_minutes     = 5
      }
    }

    critical = {
      bgp_availability = {
        enabled            = true
        warning_threshold  = 99.95
        critical_threshold = 99.5
        window_minutes     = 1
      }
      arp_availability = {
        enabled            = true
        warning_threshold  = 99.95
        critical_threshold = 99.5
        window_minutes     = 1
      }
      bits_in = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      bits_out = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      dropped_packets_in = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 50
        window_minutes     = 5
      }
      dropped_packets_out = {
        enabled            = true
        warning_threshold  = 5
        critical_threshold = 50
        window_minutes     = 5
      }
    }
  }
}
