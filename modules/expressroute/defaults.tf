locals {
  metric_namespace = "Microsoft.Network/expressRouteCircuits"

  metrics = {
    bgp_availability = {
      name        = "BgpAvailability"
      aggregation = "Average"
      description = "BGP session availability percentage"
    }
    arp_availability = {
      name        = "ArpAvailability"
      aggregation = "Average"
      description = "ARP availability percentage"
    }
    bits_in = {
      name        = "BitsInPerSecond"
      aggregation = "Average"
      description = "Bits ingressing Azure per second"
    }
    bits_out = {
      name        = "BitsOutPerSecond"
      aggregation = "Average"
      description = "Bits egressing Azure per second"
    }
    dropped_packets_in = {
      name        = "DroppedInBitsPerSecond"
      aggregation = "Average"
      description = "Ingress bits dropped per second"
    }
    dropped_packets_out = {
      name        = "DroppedOutBitsPerSecond"
      aggregation = "Average"
      description = "Egress bits dropped per second"
    }
  }

  # Resolve final values: override -> profile -> defaults
  selected_profile = local.profiles[var.profile]

  resolved = {
    bgp_availability = {
      enabled            = coalesce(try(var.overrides.bgp_availability.enabled, null), local.selected_profile.bgp_availability.enabled)
      warning_threshold  = coalesce(try(var.overrides.bgp_availability.warning_threshold, null), local.selected_profile.bgp_availability.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.bgp_availability.critical_threshold, null), local.selected_profile.bgp_availability.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.bgp_availability.window_minutes, null), local.selected_profile.bgp_availability.window_minutes)
    }
    arp_availability = {
      enabled            = coalesce(try(var.overrides.arp_availability.enabled, null), local.selected_profile.arp_availability.enabled)
      warning_threshold  = coalesce(try(var.overrides.arp_availability.warning_threshold, null), local.selected_profile.arp_availability.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.arp_availability.critical_threshold, null), local.selected_profile.arp_availability.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.arp_availability.window_minutes, null), local.selected_profile.arp_availability.window_minutes)
    }
    bits_in = {
      enabled            = coalesce(try(var.overrides.bits_in.enabled, null), local.selected_profile.bits_in.enabled)
      warning_threshold  = coalesce(try(var.overrides.bits_in.warning_threshold, null), local.selected_profile.bits_in.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.bits_in.critical_threshold, null), local.selected_profile.bits_in.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.bits_in.window_minutes, null), local.selected_profile.bits_in.window_minutes)
    }
    bits_out = {
      enabled            = coalesce(try(var.overrides.bits_out.enabled, null), local.selected_profile.bits_out.enabled)
      warning_threshold  = coalesce(try(var.overrides.bits_out.warning_threshold, null), local.selected_profile.bits_out.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.bits_out.critical_threshold, null), local.selected_profile.bits_out.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.bits_out.window_minutes, null), local.selected_profile.bits_out.window_minutes)
    }
    dropped_packets_in = {
      enabled            = coalesce(try(var.overrides.dropped_packets_in.enabled, null), local.selected_profile.dropped_packets_in.enabled)
      warning_threshold  = coalesce(try(var.overrides.dropped_packets_in.warning_threshold, null), local.selected_profile.dropped_packets_in.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.dropped_packets_in.critical_threshold, null), local.selected_profile.dropped_packets_in.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.dropped_packets_in.window_minutes, null), local.selected_profile.dropped_packets_in.window_minutes)
    }
    dropped_packets_out = {
      enabled            = coalesce(try(var.overrides.dropped_packets_out.enabled, null), local.selected_profile.dropped_packets_out.enabled)
      warning_threshold  = coalesce(try(var.overrides.dropped_packets_out.warning_threshold, null), local.selected_profile.dropped_packets_out.warning_threshold)
      critical_threshold = coalesce(try(var.overrides.dropped_packets_out.critical_threshold, null), local.selected_profile.dropped_packets_out.critical_threshold)
      window_minutes     = coalesce(try(var.overrides.dropped_packets_out.window_minutes, null), local.selected_profile.dropped_packets_out.window_minutes)
    }
  }
}
