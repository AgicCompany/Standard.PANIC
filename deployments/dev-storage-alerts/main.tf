terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-panic-terraform-state"
    storage_account_name = "stpanicdevtfstateezdbi9"
    container_name       = "tfstate"
    key                  = "monitoring/dev-storage-alerts.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

# Reference the test storage account from test-resources
data "terraform_remote_state" "test_resources" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-panic-terraform-state"
    storage_account_name = "stpanicdevtfstateezdbi9"
    container_name       = "tfstate"
    key                  = "monitoring/test-resources.tfstate"
  }
}

# Reference the prerequisites (action groups)
data "terraform_remote_state" "prerequisites" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-panic-terraform-state"
    storage_account_name = "stpanicdevtfstateezdbi9"
    container_name       = "tfstate"
    key                  = "monitoring/prerequisites.tfstate"
  }
}

module "storage_alerts" {
  source = "git::ssh://git@github.com/ecstrim/terraform-azurerm-monitor-storage.git?ref=v1.0.2"

  resource_id         = data.terraform_remote_state.test_resources.outputs.storage_account_id
  resource_name       = data.terraform_remote_state.test_resources.outputs.storage_account_name
  resource_group_name = data.terraform_remote_state.prerequisites.outputs.resource_group_name
  profile             = "standard"

  action_group_ids = data.terraform_remote_state.prerequisites.outputs.action_group_ids
}

output "alert_ids" {
  value = module.storage_alerts.alert_ids
}

output "alert_names" {
  value = module.storage_alerts.alert_names
}
