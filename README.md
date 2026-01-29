# PANIC - Azure Monitoring Framework

A standardized, profile-based Azure monitoring solution using modular Terraform.

## Overview

PANIC provides a consistent approach to metric alerting across Azure resources. It uses:
- **Profile-based configuration** (Standard/Critical) with predefined thresholds
- **Modular design** with independent, versioned repositories per resource type
- **Override mechanism** for metric-specific customization

## Repository Structure

```
panic-az-mon-framework/
├── bootstrap/              # Terraform state backend setup
├── prerequisites/          # Log Analytics + Action Groups
├── test-resources/         # Test resources for validation
├── deployments/            # Example alert deployments
└── docs/                   # Implementation documentation
```

## Related Repositories

| Repository | Purpose |
|------------|---------|
| terraform-azurerm-monitor-base | Base alert module |
| terraform-azurerm-monitor-storage | Storage Account alerts |
| terraform-azurerm-monitor-vm | Virtual Machine alerts (planned) |
| terraform-azurerm-monitor-postgresql | PostgreSQL alerts (planned) |
| terraform-azurerm-monitor-appservice | App Service alerts (planned) |
| terraform-azurerm-monitor-appgateway | Application Gateway alerts (planned) |

## Quick Start

### 1. Deploy Bootstrap (State Backend)

```bash
cd bootstrap
terraform init
terraform apply
```

### 2. Deploy Prerequisites

```bash
cd prerequisites
# Update backend config with values from bootstrap output
terraform init
terraform apply -var-file=terraform.tfvars
```

### 3. Deploy Test Resources

```bash
cd test-resources
terraform init
terraform apply
```

### 4. Deploy Alerts

```bash
cd deployments/dev-storage-alerts
terraform init
terraform apply
```

## Profiles

| Profile | Intent |
|---------|--------|
| Standard | Default for most resources. Balanced thresholds, moderate severities. |
| Critical | For high-value resources. Tighter thresholds, higher severities. |

## Documentation

See [docs/azure-monitoring-framework-implementation-v2.md](docs/azure-monitoring-framework-implementation-v2.md) for detailed implementation guidance.

## License

MIT
