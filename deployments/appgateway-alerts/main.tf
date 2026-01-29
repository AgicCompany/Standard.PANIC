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
    key                  = "monitoring/appgateway-alerts.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "terraform_remote_state" "prerequisites" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-panic-terraform-state"
    storage_account_name = "stpanicdevtfstateezdbi9"
    container_name       = "tfstate"
    key                  = "monitoring/prerequisites.tfstate"
  }
}

data "terraform_remote_state" "test_resources" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-panic-terraform-state"
    storage_account_name = "stpanicdevtfstateezdbi9"
    container_name       = "tfstate"
    key                  = "monitoring/test-resources.tfstate"
  }
}

module "appgateway_alerts" {
  source = "git::git@github.com:ecstrim/terraform-azurerm-monitor-appgateway.git?ref=v1.0.0"

  resource_id         = data.terraform_remote_state.test_resources.outputs.application_gateway_id
  resource_name       = data.terraform_remote_state.test_resources.outputs.application_gateway_name
  resource_group_name = data.terraform_remote_state.prerequisites.outputs.resource_group_name
  profile             = "standard"

  action_group_ids = {
    critical = data.terraform_remote_state.prerequisites.outputs.action_group_ids.critical
    warning  = data.terraform_remote_state.prerequisites.outputs.action_group_ids.warning
  }

  tags = {
    environment = "test"
    module      = "appgateway"
  }
}
