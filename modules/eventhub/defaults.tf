locals {
  # Metric namespace for Azure Event Hubs
  metric_namespace = "Microsoft.EventHub/namespaces"

  # Metric definitions
  metrics = {
    throttled_requests = {
      name        = "ThrottledRequests"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Throttled requests"
    }
    quota_exceeded = {
      name        = "QuotaExceededErrors"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Quota exceeded errors"
    }
    server_errors = {
      name        = "ServerErrors"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Server-side errors"
    }
    incoming_messages = {
      name        = "IncomingMessages"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Incoming messages"
    }
    capture_backlog = {
      name        = "CaptureBacklog"
      aggregation = "Total"
      operator    = "GreaterThan"
      description = "Capture backlog"
    }
  }

  # Select the profile
  selected_profile = local.profiles[var.profile]

  # Resolved configuration with overrides
  resolved = {
    throttled_requests = {
      enabled            = coalesce(try(var.overrides.throttled_requests.enabled, null), local.selected_profile.throttled_requests.enabled)
      warning_threshold  = coalesce(try(var.overrides.throttled_requests.warning_threshold, null), local.selected_profile.throttled_requests.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.throttled_requests.critical_threshold, null), local.selected_profile.throttled_requests.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.throttled_requests.window_minutes, null), local.selected_profile.throttled_requests.window_minutes)
    }
    quota_exceeded = {
      enabled            = coalesce(try(var.overrides.quota_exceeded.enabled, null), local.selected_profile.quota_exceeded.enabled)
      warning_threshold  = coalesce(try(var.overrides.quota_exceeded.warning_threshold, null), local.selected_profile.quota_exceeded.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.quota_exceeded.critical_threshold, null), local.selected_profile.quota_exceeded.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.quota_exceeded.window_minutes, null), local.selected_profile.quota_exceeded.window_minutes)
    }
    server_errors = {
      enabled            = coalesce(try(var.overrides.server_errors.enabled, null), local.selected_profile.server_errors.enabled)
      warning_threshold  = coalesce(try(var.overrides.server_errors.warning_threshold, null), local.selected_profile.server_errors.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.server_errors.critical_threshold, null), local.selected_profile.server_errors.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.server_errors.window_minutes, null), local.selected_profile.server_errors.window_minutes)
    }
    incoming_messages = {
      enabled            = coalesce(try(var.overrides.incoming_messages.enabled, null), local.selected_profile.incoming_messages.enabled)
      warning_threshold  = coalesce(try(var.overrides.incoming_messages.warning_threshold, null), local.selected_profile.incoming_messages.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.incoming_messages.critical_threshold, null), local.selected_profile.incoming_messages.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.incoming_messages.window_minutes, null), local.selected_profile.incoming_messages.window_minutes)
    }
    capture_backlog = {
      enabled            = coalesce(try(var.overrides.capture_backlog.enabled, null), local.selected_profile.capture_backlog.enabled)
      warning_threshold  = coalesce(try(var.overrides.capture_backlog.warning_threshold, null), local.selected_profile.capture_backlog.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.capture_backlog.critical_threshold, null), local.selected_profile.capture_backlog.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.capture_backlog.window_minutes, null), local.selected_profile.capture_backlog.window_minutes)
    }
  }

  # Common tags
  common_tags = merge(var.tags, {
    managed-by = "terraform"
  })
}
