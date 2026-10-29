locals {
  # Profile definitions based on implementation guide
  # Note: Memory and Disk Free % use LessThan operator (lower values = worse)
  # memory and disk_free are disabled by default (disk_free needs Azure Monitor Agent guest metrics, see README)
  profiles = {
    standard = {
      cpu = {
        enabled            = true
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      memory = {
        enabled            = false # Opt-in: platform metric, no agent needed
        warning_threshold  = 15    # Alert when < 15% available
        critical_threshold = 10    # Alert when < 10% available
        window_minutes     = 5
      }
      os_disk_iops = {
        enabled            = true
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      data_disk_iops = {
        enabled            = true
        warning_threshold  = 85
        critical_threshold = 95
        window_minutes     = 5
      }
      disk_free = {
        enabled            = false # Needs Azure Monitor Agent guest metrics, see README
        warning_threshold  = 15    # Alert when < 15% free
        critical_threshold = 10    # Alert when < 10% free
        window_minutes     = 15
      }
      availability = {
        enabled            = true
        critical_threshold = 1 # Alert when < 1 (VM unavailable)
        window_minutes     = 1
      }
    }
    critical = {
      cpu = {
        enabled            = true
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      memory = {
        enabled            = false # Opt-in: platform metric, no agent needed
        warning_threshold  = 20    # Alert when < 20% available
        critical_threshold = 15    # Alert when < 15% available
        window_minutes     = 5
      }
      os_disk_iops = {
        enabled            = true
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      data_disk_iops = {
        enabled            = true
        warning_threshold  = 75
        critical_threshold = 90
        window_minutes     = 5
      }
      disk_free = {
        enabled            = false # Needs Azure Monitor Agent guest metrics, see README
        warning_threshold  = 20    # Alert when < 20% free
        critical_threshold = 15    # Alert when < 15% free
        window_minutes     = 15
      }
      availability = {
        enabled            = true
        critical_threshold = 1 # Alert when < 1 (VM unavailable)
        window_minutes     = 1
      }
    }
  }

  # Select the active profile
  active_profile = local.profiles[var.profile]
}
