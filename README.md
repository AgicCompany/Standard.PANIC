# PANIC - Azure Monitoring Framework

Profile-based Azure monitoring with Terraform. Standardized alerting across 22 Azure resource types.

## Key Features

- **Profile-based configuration** - Standard and Critical profiles with predefined thresholds
- **Modular design** - Independent, versioned modules per resource type
- **Override mechanism** - Customize any metric while keeping profile defaults
- **Terraform native** - Deploy alerts as code with remote state support

## Documentation

| Document | Description |
|----------|-------------|
| [Getting Started](docs/getting-started.md) | Prerequisites and quick start guide |
| [Modules](docs/modules.md) | Full list of available resource modules |
| [Profiles](docs/profiles.md) | Profile system and threshold overview |
| [Architecture](docs/architecture.md) | Framework design and override mechanism |
| [Implementation Guide](docs/implementation-v2.md) | Complete technical reference |

## Quick Example

```hcl
module "vm_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.terraform-azurerm-monitor-vm.git?ref=v1.0.0"

  resource_id    = azurerm_virtual_machine.example.id
  resource_name  = "myapp-vm01"
  profile        = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

## Repository Structure

```
Standard.PANIC/
├── docs/                 # Documentation
├── bootstrap/            # Terraform state backend setup
├── prerequisites/        # Log Analytics + Action Groups
└── deployments/          # Example alert deployments
```

## License

MIT
