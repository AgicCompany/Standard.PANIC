locals {
  # Metric namespace for Azure Service Bus
  metric_namespace = "Microsoft.ServiceBus/namespaces"

  # Metric definitions
  metrics = {
    active_messages = {
      name        = "ActiveMessages"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Active messages in queues/topics"
    }
    deadlettered_messages = {
      name        = "DeadletteredMessages"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Dead-lettered messages"
    }
    throttled_requests = {
      name        = "ThrottledRequests"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Throttled requests"
    }
    server_errors = {
      name        = "ServerErrors"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Server-side errors"
    }
    size = {
      name        = "Size"
      aggregation = "Average"
      operator    = "GreaterThan"
      description = "Namespace size in bytes"
    }
  }

  # Select the profile
  selected_profile = local.profiles[var.profile]

  # Resolved configuration with overrides
  resolved = {
    active_messages = {
      enabled            = coalesce(try(var.overrides.active_messages.enabled, null), local.selected_profile.active_messages.enabled)
      warning_threshold  = coalesce(try(var.overrides.active_messages.warning_threshold, null), local.selected_profile.active_messages.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.active_messages.critical_threshold, null), local.selected_profile.active_messages.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.active_messages.window_minutes, null), local.selected_profile.active_messages.window_minutes)
    }
    deadlettered_messages = {
      enabled            = coalesce(try(var.overrides.deadlettered_messages.enabled, null), local.selected_profile.deadlettered_messages.enabled)
      warning_threshold  = coalesce(try(var.overrides.deadlettered_messages.warning_threshold, null), local.selected_profile.deadlettered_messages.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.deadlettered_messages.critical_threshold, null), local.selected_profile.deadlettered_messages.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.deadlettered_messages.window_minutes, null), local.selected_profile.deadlettered_messages.window_minutes)
    }
    throttled_requests = {
      enabled            = coalesce(try(var.overrides.throttled_requests.enabled, null), local.selected_profile.throttled_requests.enabled)
      warning_threshold  = coalesce(try(var.overrides.throttled_requests.warning_threshold, null), local.selected_profile.throttled_requests.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.throttled_requests.critical_threshold, null), local.selected_profile.throttled_requests.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.throttled_requests.window_minutes, null), local.selected_profile.throttled_requests.window_minutes)
    }
    server_errors = {
      enabled            = coalesce(try(var.overrides.server_errors.enabled, null), local.selected_profile.server_errors.enabled)
      warning_threshold  = coalesce(try(var.overrides.server_errors.warning_threshold, null), local.selected_profile.server_errors.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.server_errors.critical_threshold, null), local.selected_profile.server_errors.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.server_errors.window_minutes, null), local.selected_profile.server_errors.window_minutes)
    }
    size = {
      enabled            = coalesce(try(var.overrides.size.enabled, null), local.selected_profile.size.enabled)
      warning_threshold  = coalesce(try(var.overrides.size.warning_threshold, null), local.selected_profile.size.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.size.critical_threshold, null), local.selected_profile.size.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.size.window_minutes, null), local.selected_profile.size.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
