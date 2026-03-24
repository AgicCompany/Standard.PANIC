locals {
  # Metric namespace for Azure Kubernetes Service
  metric_namespace = "Microsoft.ContainerService/managedClusters"

  # Metric definitions
  metrics = {
    node_cpu = {
      name        = "node_cpu_usage_percentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Node CPU usage percentage"
    }
    node_memory = {
      name        = "node_memory_working_set_percentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Node memory working set percentage"
    }
    node_disk = {
      name        = "node_disk_usage_percentage"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Node disk usage percentage"
    }
    pod_ready = {
      name        = "kube_pod_status_ready"
      aggregation = "Average"
      operator    = "LessThan"
      description = "Percentage of pods in ready state"
    }
    node_count = {
      name        = "kube_node_status_condition"
      aggregation = "Total"
      operator    = "LessThan"
      description = "Number of ready nodes"
    }
  }

  # Select the profile
  selected_profile = local.profiles[var.profile]

  # Resolved configuration with overrides
  resolved = {
    node_cpu = {
      enabled            = coalesce(try(var.overrides.node_cpu.enabled, null), local.selected_profile.node_cpu.enabled)
      warning_threshold  = coalesce(try(var.overrides.node_cpu.warning_threshold, null), local.selected_profile.node_cpu.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.node_cpu.critical_threshold, null), local.selected_profile.node_cpu.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.node_cpu.window_minutes, null), local.selected_profile.node_cpu.window_minutes)
    }
    node_memory = {
      enabled            = coalesce(try(var.overrides.node_memory.enabled, null), local.selected_profile.node_memory.enabled)
      warning_threshold  = coalesce(try(var.overrides.node_memory.warning_threshold, null), local.selected_profile.node_memory.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.node_memory.critical_threshold, null), local.selected_profile.node_memory.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.node_memory.window_minutes, null), local.selected_profile.node_memory.window_minutes)
    }
    node_disk = {
      enabled            = coalesce(try(var.overrides.node_disk.enabled, null), local.selected_profile.node_disk.enabled)
      warning_threshold  = coalesce(try(var.overrides.node_disk.warning_threshold, null), local.selected_profile.node_disk.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.node_disk.critical_threshold, null), local.selected_profile.node_disk.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.node_disk.window_minutes, null), local.selected_profile.node_disk.window_minutes)
    }
    pod_ready = {
      enabled            = coalesce(try(var.overrides.pod_ready.enabled, null), local.selected_profile.pod_ready.enabled)
      warning_threshold  = coalesce(try(var.overrides.pod_ready.warning_threshold, null), local.selected_profile.pod_ready.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.pod_ready.critical_threshold, null), local.selected_profile.pod_ready.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.pod_ready.window_minutes, null), local.selected_profile.pod_ready.window_minutes)
    }
    node_count = {
      enabled            = coalesce(try(var.overrides.node_count.enabled, null), local.selected_profile.node_count.enabled)
      warning_threshold  = coalesce(try(var.overrides.node_count.warning_threshold, null), local.selected_profile.node_count.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.node_count.critical_threshold, null), local.selected_profile.node_count.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.node_count.window_minutes, null), local.selected_profile.node_count.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
