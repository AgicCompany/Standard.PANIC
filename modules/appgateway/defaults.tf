locals {
  metric_namespace = "Microsoft.Network/applicationGateways"

  metrics = {
    unhealthy_hosts = {
      name        = "UnhealthyHostCount"
      aggregation = "Average"
      description = "Number of unhealthy backend hosts"
    }
    backend_5xx = {
      name        = "BackendResponseStatus"
      aggregation = "Total"
      description = "Backend HTTP 5xx response count"
      dimension = {
        name     = "HttpStatusGroup"
        operator = "Include"
        values   = ["5xx"]
      }
    }
    cpu = {
      name        = "CpuUtilization"
      aggregation = "Average"
      description = "CPU utilization percentage"
    }
    capacity_units = {
      name        = "CapacityUnits"
      aggregation = "Average"
      description = "Capacity units consumed"
    }
    failed_requests = {
      name        = "FailedRequests"
      aggregation = "Total"
      description = "Count of failed requests"
    }
    response_5xx = {
      name        = "ResponseStatus"
      aggregation = "Total"
      description = "HTTP 5xx response status from gateway"
      dimension = {
        name     = "HttpStatusGroup"
        operator = "Include"
        values   = ["5xx"]
      }
    }
  }

  # Resolve final values: override -> profile -> defaults
  selected_profile = local.profiles[var.profile]

  resolved = {
    unhealthy_hosts = {
      enabled            = coalesce(try(var.overrides.unhealthy_hosts.enabled, null), local.selected_profile.unhealthy_hosts.enabled)
      warning_threshold  = coalesce(try(var.overrides.unhealthy_hosts.warning_threshold, null), local.selected_profile.unhealthy_hosts.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.unhealthy_hosts.critical_threshold, null), local.selected_profile.unhealthy_hosts.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.unhealthy_hosts.window_minutes, null), local.selected_profile.unhealthy_hosts.window_minutes)
    }
    backend_5xx = {
      enabled            = coalesce(try(var.overrides.backend_5xx.enabled, null), local.selected_profile.backend_5xx.enabled)
      warning_threshold  = coalesce(try(var.overrides.backend_5xx.warning_threshold, null), local.selected_profile.backend_5xx.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.backend_5xx.critical_threshold, null), local.selected_profile.backend_5xx.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.backend_5xx.window_minutes, null), local.selected_profile.backend_5xx.window_minutes)
    }
    cpu = {
      enabled            = coalesce(try(var.overrides.cpu.enabled, null), local.selected_profile.cpu.enabled)
      warning_threshold  = coalesce(try(var.overrides.cpu.warning_threshold, null), local.selected_profile.cpu.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.cpu.critical_threshold, null), local.selected_profile.cpu.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.cpu.window_minutes, null), local.selected_profile.cpu.window_minutes)
    }
    capacity_units = {
      enabled            = coalesce(try(var.overrides.capacity_units.enabled, null), local.selected_profile.capacity_units.enabled)
      warning_threshold  = coalesce(try(var.overrides.capacity_units.warning_threshold, null), local.selected_profile.capacity_units.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.capacity_units.critical_threshold, null), local.selected_profile.capacity_units.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.capacity_units.window_minutes, null), local.selected_profile.capacity_units.window_minutes)
    }
    failed_requests = {
      enabled            = coalesce(try(var.overrides.failed_requests.enabled, null), local.selected_profile.failed_requests.enabled)
      warning_threshold  = coalesce(try(var.overrides.failed_requests.warning_threshold, null), local.selected_profile.failed_requests.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.failed_requests.critical_threshold, null), local.selected_profile.failed_requests.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.failed_requests.window_minutes, null), local.selected_profile.failed_requests.window_minutes)
    }
    response_5xx = {
      enabled            = coalesce(try(var.overrides.response_5xx.enabled, null), local.selected_profile.response_5xx.enabled)
      warning_threshold  = coalesce(try(var.overrides.response_5xx.warning_threshold, null), local.selected_profile.response_5xx.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.response_5xx.critical_threshold, null), local.selected_profile.response_5xx.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.response_5xx.window_minutes, null), local.selected_profile.response_5xx.window_minutes)
    }
  }
}
