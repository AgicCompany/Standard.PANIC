locals {
  profiles = {
    standard = {
      node_cpu = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      node_memory = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 95
        window_minutes     = 5
      }
      node_disk = {
        enabled            = true
        warning_threshold  = 80
        critical_threshold = 90
        window_minutes     = 15
      }
      pod_ready = {
        enabled            = true
        warning_threshold  = 80 # percentage of pods ready
        critical_threshold = 50
        window_minutes     = 5
      }
      node_count = {
        enabled            = false # Enable and set threshold based on cluster size
        warning_threshold  = 3     # minimum node count
        critical_threshold = 1
        window_minutes     = 5
      }
    }

    critical = {
      node_cpu = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      node_memory = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 90
        window_minutes     = 5
      }
      node_disk = {
        enabled            = true
        warning_threshold  = 70
        critical_threshold = 85
        window_minutes     = 15
      }
      pod_ready = {
        enabled            = true
        warning_threshold  = 90
        critical_threshold = 70
        window_minutes     = 5
      }
      node_count = {
        enabled            = false
        warning_threshold  = 5
        critical_threshold = 3
        window_minutes     = 5
      }
    }
  }
}
