<p align="center">
  <img src="images/PANIC_LOGO.png" alt="PANIC Logo" width="150">
</p>

# PANIC - Azure Monitoring Framework

Terraform modules that create Azure Monitor metric alerts from predefined profiles.

You point a module at an Azure resource and choose a profile: `standard` or `critical`. The module creates a warning alert and a critical alert for each metric that matters for that resource type. You can override any threshold without giving up the rest of the profile.

- 22 resource modules, from VMs and SQL to AKS and Service Bus, plus a generic `base` module for single alerts.
- Alerts live in their own Terraform layer, separate from the resources they watch.
- Each module is versioned on its own, so upgrading one never forces another.

## Quick example

```hcl
module "vm_alerts" {
  source = "git::https://github.com/AgicCompany/Standard.PANIC.git//modules/vm?ref=vm/v1.0.1"

  resource_id         = azurerm_linux_virtual_machine.app.id
  resource_name       = "myapp-vm01"
  resource_group_name = "rg-monitoring-prod"
  profile             = "critical"

  action_group_ids = {
    critical = azurerm_monitor_action_group.critical.id
    warning  = azurerm_monitor_action_group.warning.id
  }
}
```

This creates alert rules such as `myapp-vm01-cpu-warn` and `myapp-vm01-cpu-crit` in `rg-monitoring-prod`.

## Documentation

| I want to... | Read |
|--------------|------|
| Deploy my first alerts | [Getting started](docs/getting-started.md) |
| Understand profiles, overrides and naming | [Concepts](docs/concepts.md) |
| Find the module for a resource type | [Modules](docs/modules.md) |
| See every metric and threshold | [Thresholds](docs/thresholds.md) |
| Monitor a whole subscription | [Subscription template](docs/subscription-template.md) |
| Pin or upgrade module versions | [Versioning](docs/versioning.md) |
| Change or add a module | [Contributing](docs/contributing.md) |

Each module also has its own README under `modules/<name>/`, with runnable examples in `modules/<name>/examples/`.

## Repository layout

```
modules/        one alert module per resource type, plus base/
templates/      panic-subscription-template: all modules behind feature switches
bootstrap/      storage account for Terraform remote state
prerequisites/  monitoring resource group, Log Analytics, action groups
deployments/    worked examples that use the modules from this repo
test-resources/ throwaway Azure resources to aim alerts at while testing
docs/           guides and reference; docs/specs/ holds design records
```

## License

MIT
