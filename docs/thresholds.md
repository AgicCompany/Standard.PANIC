---
title: Thresholds
date: 2026-09-28
status: draft
version: 0.1
---

# Thresholds

Every metric in every module, with its default thresholds for both profiles.

This page is generated from each module's `profiles.tf`, `defaults.tf` and `main.tf`. If it disagrees with the code, the code wins. See [Contributing](contributing.md#regenerating-thresholdsmd).

How to read the tables:

- **Override key**: the key to use in `overrides`. "(off)" means the metric is disabled by default in both profiles.
- **Alert suffix**: alert rules are named `{resource_name}-{suffix}-warn` and `{resource_name}-{suffix}-crit`.
- **Op**: the alert fires when the metric value is on this side of the threshold. `<` means lower is worse, for example availability or free space.
- **Window**: evaluation window in minutes. Alerts evaluate every minute.
- **warn / crit**: warning (severity 2) and critical (severity 1) thresholds. `-` means the metric has no warning alert.
- Thresholds use the Azure metric's own unit: percent, milliseconds, bytes, or a count per window.

<!-- GENERATED: tables below are written by scripts/gen-thresholds.py -->

### AKS (`aks`)

Namespace: `Microsoft.ContainerService/managedClusters`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `node_cpu` | `nodecpu` | node_cpu_usage_percentage | Average | > | 5 | 80 / 95 | 70 / 90 |
| `node_memory` | `nodememory` | node_memory_working_set_percentage | Average | > | 5 | 80 / 95 | 70 / 90 |
| `node_disk` | `nodedisk` | node_disk_usage_percentage | Average | > | 15 | 80 / 90 | 70 / 85 |
| `pod_ready` | `podready` | kube_pod_status_ready | Average | < | 5 | 80 / 50 | 90 / 70 |
| `node_count` (off) | `nodecount` | kube_node_status_condition | Total | < | 5 | 3 / 1 | 5 / 3 |

### App Service (`appservice`)

Namespace: `Microsoft.Web/sites`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `cpu` (off) | `cpu` | CpuTime | Total | > | 5 | 300 / 600 | 200 / 400 |
| `memory` (off) | `memory` | AverageMemoryWorkingSet | Average | > | 5 | 1073741824 / 1610612736 | 536870912 / 1073741824 |
| `http_5xx` | `http5xx` | Http5xx | Total | > | 5 | 10 / 50 | 5 / 25 |
| `response_time` | `responsetime` | HttpResponseTime | Average | > | 5 | 2000 / 5000 | 1000 / 3000 |
| `health_check` | `health` | HealthCheckStatus | Average | < | 5 | - / 1 | - / 1 |

### Application Gateway (`appgateway`)

Namespace: `Microsoft.Network/applicationGateways`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `unhealthy_hosts` | `unhealthy-hosts` | UnhealthyHostCount | Average | >= | 5 | 1 / 2 | 1 / 1 |
| `backend_5xx` | `backend-5xx` | BackendResponseStatus | Total | > | 5 | 10 / 50 | 5 / 25 |
| `cpu` (off) | `cpu` | CpuUtilization | Average | > | 5 | 80 / 95 | 70 / 90 |
| `capacity_units` | `capacity-units` | CapacityUnits | Average | > | 5 | 70 / 90 | 60 / 80 |
| `failed_requests` | `failed-requests` | FailedRequests | Total | > | 5 | 50 / 200 | 25 / 100 |
| `response_5xx` | `response-5xx` | ResponseStatus | Total | > | 5 | 10 / 50 | 5 / 25 |

### Azure Firewall (`firewall`)

Namespace: `Microsoft.Network/azureFirewalls`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `health_state` | `health` | FirewallHealth | Average | < | 1 | 99 / 95 | 99.5 / 99 |
| `throughput` | `throughput` | Throughput | Average | > | 5 | 80 / 95 | 70 / 90 |
| `snat_port_utilization` | `snat-util` | SNATPortUtilization | Average | > | 5 | 80 / 95 | 70 / 90 |
| `latency` | `latency` | FirewallLatencyProbe | Average | > | 5 | 20 / 50 | 10 / 30 |

### Azure SQL Database (`sqldb`)

Namespace: `Microsoft.Sql/servers/databases`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `cpu` | `cpu` | cpu_percent | Average | > | 5 | 80 / 95 | 70 / 90 |
| `dtu` | `dtu` | dtu_consumption_percent | Average | > | 5 | 80 / 95 | 70 / 90 |
| `storage` | `storage` | storage_percent | Average | > | 15 | 80 / 90 | 70 / 85 |
| `deadlocks` | `deadlocks` | deadlock | Total | > | 5 | 5 / 20 | 2 / 10 |
| `connection_failed` | `connfail` | connection_failed | Total | > | 5 | 10 / 50 | 5 / 25 |
| `sessions` | `sessions` | sessions_percent | Average | > | 5 | 80 / 95 | 70 / 90 |
| `workers` | `workers` | workers_percent | Average | > | 5 | 80 / 95 | 70 / 90 |

### Container App (`containerapp`)

Namespace: `Microsoft.App/containerApps`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `cpu` | `cpu` | UsageNanoCores | Average | > | 5 | 70 / 90 | 60 / 80 |
| `memory` | `memory` | WorkingSetBytes | Average | > | 5 | 70 / 90 | 60 / 80 |
| `restarts` | `restarts` | RestartCount | Maximum | > | 15 | 3 / 10 | 1 / 5 |
| `replicas` (off) | `replicas` | Replicas | Average | < | 5 | 2 / 1 | 3 / 2 |
| `requests` (off) | `requests` | Requests | Total | > | 5 | 10000 / 50000 | 10000 / 50000 |

### Cosmos DB (`cosmosdb`)

Namespace: `Microsoft.DocumentDB/databaseAccounts`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `ru_consumption` | `ru` | NormalizedRUConsumption | Maximum | > | 5 | 70 / 90 | 60 / 80 |
| `availability` | `availability` | ServiceAvailability | Average | < | 5 | 99.9 / 99 | 99.95 / 99.5 |
| `server_latency` | `latency` | ServerSideLatency | Average | > | 5 | 50 / 100 | 30 / 75 |
| `throttled_requests` | `throttled` | TotalRequests | Count | > | 5 | 10 / 50 | 5 / 25 |
| `total_requests` (off) | `requests` | TotalRequests | Count | > | 5 | 10000 / 50000 | 10000 / 50000 |

### Event Hub Namespace (`eventhub`)

Namespace: `Microsoft.EventHub/namespaces`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `throttled_requests` | `throttled` | ThrottledRequests | Total | > | 5 | 5 / 20 | 1 / 10 |
| `quota_exceeded` | `quotaexceeded` | QuotaExceededErrors | Total | > | 5 | 1 / 10 | 1 / 5 |
| `server_errors` | `servererrors` | ServerErrors | Total | > | 5 | 5 / 20 | 1 / 10 |
| `incoming_messages` (off) | `incomingmsg` | IncomingMessages | Total | > | 5 | 100000 / 500000 | 100000 / 500000 |
| `capture_backlog` (off) | `capturebacklog` | CaptureBacklog | Total | > | 5 | 1000 / 10000 | 500 / 5000 |

### ExpressRoute Circuit (`expressroute`)

Namespace: `Microsoft.Network/expressRouteCircuits`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `bgp_availability` | `bgp-avail` | BgpAvailability | Average | < | 1 | 99.9 / 99 | 99.95 / 99.5 |
| `arp_availability` | `arp-avail` | ArpAvailability | Average | < | 1 | 99.9 / 99 | 99.95 / 99.5 |
| `bits_in` | `bits-in` | BitsInPerSecond | Average | > | 5 | 80 / 95 | 70 / 90 |
| `bits_out` | `bits-out` | BitsOutPerSecond | Average | > | 5 | 80 / 95 | 70 / 90 |
| `dropped_packets_in` | `drops-in` | DroppedInBitsPerSecond | Average | > | 5 | 10 / 100 | 5 / 50 |
| `dropped_packets_out` | `drops-out` | DroppedOutBitsPerSecond | Average | > | 5 | 10 / 100 | 5 / 50 |

### Function App (`function`)

Namespace: `Microsoft.Web/sites`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `http_5xx` | `http5xx` | Http5xx | Total | > | 5 | 5 / 20 | 1 / 10 |
| `http_4xx` (off) | `http4xx` | Http4xx | Total | > | 5 | 50 / 200 | 25 / 100 |
| `response_time` | `responsetime` | AverageResponseTime | Average | > | 5 | 5 / 10 | 2 / 5 |
| `memory` | `memory` | MemoryWorkingSet | Average | > | 5 | 80 / 95 | 70 / 90 |
| `execution_count` (off) | `executions` | FunctionExecutionCount | Total | > | 5 | 10000 / 50000 | 10000 / 50000 |

### Key Vault (`keyvault`)

Namespace: `Microsoft.KeyVault/vaults`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `availability` | `availability` | Availability | Average | < | 5 | 99 / 95 | 99.9 / 99 |
| `latency` | `latency` | ServiceApiLatency | Average | > | 5 | 500 / 1000 | 200 / 500 |
| `saturation` | `saturation` | SaturationShoebox | Average | > | 15 | 70 / 90 | 60 / 80 |
| `api_hits` (off) | `apihits` | ServiceApiHit | Total | > | 5 | 10000 / 50000 | 10000 / 50000 |

### Load Balancer (`lb`)

Namespace: `Microsoft.Network/loadBalancers`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `health_probe_status` | `health-probe` | DipAvailability | Average | < | 1 | - / 1 | - / 1 |
| `data_path_availability` | `data-path` | VipAvailability | Average | < | 1 | 99.9 / 99 | 99.95 / 99.5 |
| `snat_connection_count` | `snat-conn` | SnatConnectionCount | Total | > | 5 | 80 / 95 | 70 / 90 |
| `used_snat_ports` | `snat-ports` | UsedSnatPorts | Average | > | 5 | 80 / 95 | 70 / 90 |

### Managed Disk (`disk`)

Namespace: `Microsoft.Compute/disks`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `iops_consumed` | `iops-consumed` | Composite Disk Read Operations/sec | Average | > | 5 | 85 / 95 | 75 / 90 |
| `bandwidth_consumed` | `bandwidth-consumed` | Composite Disk Read Bytes/sec | Average | > | 5 | 85 / 95 | 75 / 90 |
| `queue_depth` | `queue-depth` | Composite Disk Read Operations/sec | Average | > | 5 | 32 / 64 | 16 / 32 |
| `burst_bps_credits` (off) | `burst-bps-credits` | BurstBPSCreditsPercent | Average | < | 5 | 20 / 10 | 30 / 20 |
| `burst_io_credits` (off) | `burst-io-credits` | BurstIOCreditsPercent | Average | < | 5 | 20 / 10 | 30 / 20 |

### MySQL Flexible Server (`mysql`)

Namespace: `Microsoft.DBforMySQL/flexibleServers`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `cpu` | `cpu` | cpu_percent | Average | > | 5 | 80 / 95 | 70 / 90 |
| `memory` | `memory` | memory_percent | Average | > | 5 | 80 / 95 | 70 / 90 |
| `storage` | `storage` | storage_percent | Average | > | 15 | 80 / 90 | 70 / 85 |
| `io` | `io` | io_consumption_percent | Average | > | 5 | 80 / 95 | 70 / 90 |
| `connections` | `connections` | active_connections | Average | > | 5 | 80 / 95 | 70 / 90 |
| `aborted_connections` | `abortedconn` | aborted_connections | Total | > | 5 | 10 / 50 | 5 / 25 |
| `replication_lag` (off) | `repllag` | replication_lag | Maximum | > | 5 | 30 / 60 | 15 / 30 |

### PostgreSQL Flexible Server (`postgresql`)

Namespace: `Microsoft.DBforPostgreSQL/flexibleServers`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `cpu` | `cpu` | cpu_percent | Average | > | 5 | 80 / 95 | 70 / 90 |
| `memory` | `memory` | memory_percent | Average | > | 5 | 80 / 95 | 70 / 90 |
| `storage` | `storage` | storage_percent | Average | > | 15 | 80 / 90 | 70 / 85 |
| `connections` | `connections` | active_connections | Average | > | 5 | 80 / 90 | 70 / 85 |
| `failed_connections` | `failedconn` | connections_failed | Total | > | 5 | 10 / 50 | 5 / 25 |
| `availability` | `availability` | is_db_alive | Minimum | < | 1 | - / 1 | - / 1 |
| `replication_lag` (off) | `repllag` | physical_replication_delay_in_seconds | Maximum | > | 5 | 30 / 60 | 10 / 30 |

### Redis Cache (`redis`)

Namespace: `Microsoft.Cache/redis`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `server_load` | `serverload` | serverLoad | Average | > | 5 | 70 / 90 | 60 / 80 |
| `memory` | `memory` | usedmemorypercentage | Average | > | 5 | 70 / 90 | 60 / 80 |
| `connected_clients` | `clients` | connectedclients | Maximum | > | 5 | 80 / 95 | 70 / 90 |
| `cache_miss_rate` (off) | `cachemiss` | cachemissrate | Average | > | 5 | 50 / 80 | 30 / 60 |
| `evicted_keys` | `evictedkeys` | evictedkeys | Total | > | 5 | 100 / 1000 | 10 / 100 |

### Service Bus Namespace (`servicebus`)

Namespace: `Microsoft.ServiceBus/namespaces`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `active_messages` | `activemsg` | ActiveMessages | Average | > | 5 | 1000 / 5000 | 500 / 2000 |
| `deadlettered_messages` | `deadletter` | DeadletteredMessages | Average | > | 5 | 10 / 100 | 1 / 50 |
| `throttled_requests` | `throttled` | ThrottledRequests | Total | > | 5 | 5 / 20 | 1 / 10 |
| `server_errors` | `servererrors` | ServerErrors | Total | > | 5 | 5 / 20 | 1 / 10 |
| `size` | `size` | Size | Average | > | 15 | 80 / 90 | 70 / 85 |

### SQL Managed Instance (`sqlmi`)

Namespace: `Microsoft.Sql/managedInstances`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `cpu` | `cpu` | avg_cpu_percent | Average | > | 5 | 80 / 95 | 70 / 90 |
| `storage` | `storage` | storage_space_used_mb | Average | > | 15 | 80 / 90 | 70 / 85 |
| `io_requests` | `iops` | io_requests | Average | > | 5 | 80 / 95 | 70 / 90 |
| `io_bytes` | `iothroughput` | io_bytes_read | Average | > | 5 | 80 / 95 | 70 / 90 |

### Storage Account (`storage`)

Namespace: `Microsoft.Storage/storageAccounts`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `availability` | `availability` | Availability | Average | < | 5 | 99.9 / 99 | 99.95 / 99.5 |
| `latency` | `latency` | SuccessE2ELatency | Average | > | 5 | 500 / 1000 | 250 / 500 |
| `throttling` | `throttling` | Transactions | Total | > | 5 | 10 / 100 | 5 / 50 |
| `used_capacity` | `capacity` | UsedCapacity | Average | > | 60 | 80 / 90 | 70 / 85 |

### Virtual Machine (`vm`)

Namespace: `Microsoft.Compute/virtualMachines`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `cpu` | `cpu` | Percentage CPU | Average | > | 5 | 85 / 95 | 75 / 90 |
| `memory` (off) | `memory` | Available Memory Bytes | Average | < | 5 | 15 / 10 | 20 / 15 |
| `os_disk_iops` | `osdiskiops` | OS Disk IOPS Consumed Percentage | Average | > | 5 | 85 / 95 | 75 / 90 |
| `data_disk_iops` | `datadiskiops` | Data Disk IOPS Consumed Percentage | Average | > | 5 | 85 / 95 | 75 / 90 |
| `disk_free` (off) | `diskfree` | Logical Disk Free Space Percentage | Average | < | 15 | 15 / 10 | 20 / 15 |
| `availability` | `availability` | VmAvailabilityMetric | Average | < | 1 | - / 1 | - / 1 |

### Virtual Machine Scale Set (`vmss`)

Namespace: `Microsoft.Compute/virtualMachineScaleSets`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `cpu` | `cpu` | Percentage CPU | Average | > | 5 | 85 / 95 | 75 / 90 |
| `memory` | `memory` | Available Memory Percentage | Average | < | 5 | 15 / 10 | 20 / 15 |
| `os_disk_iops` | `osdiskiops` | OS Disk IOPS Consumed Percentage | Average | > | 5 | 85 / 95 | 75 / 90 |
| `data_disk_iops` | `datadiskiops` | Data Disk IOPS Consumed Percentage | Average | > | 5 | 85 / 95 | 75 / 90 |
| `availability` | `availability` | VmAvailabilityMetric | Average | < | 5 | 1 / 0.5 | 1 / 0.75 |

### VPN Gateway (`vpngw`)

Namespace: `Microsoft.Network/virtualNetworkGateways`

| Override key | Alert suffix | Azure metric | Agg | Op | Window (min) | Standard warn / crit | Critical warn / crit |
|---|---|---|---|---|---|---|---|
| `tunnel_status` | `tunnel-status` | TunnelAverageBandwidth | Average | < | 1 | - / 1 | - / 1 |
| `tunnel_bandwidth` | `tunnel-bw` | TunnelAverageBandwidth | Average | > | 5 | 80 / 95 | 70 / 90 |
| `p2s_bandwidth` (off) | `p2s-bw` | P2SBandwidth | Average | > | 5 | 80 / 95 | 70 / 90 |
| `p2s_connection_count` (off) | `p2s-conn` | P2SConnectionCount | Total | > | 5 | 80 / 95 | 70 / 90 |
| `tunnel_drop_count` | `tunnel-drops` | TunnelDropCount | Total | > | 5 | 5 / 20 | 2 / 10 |
