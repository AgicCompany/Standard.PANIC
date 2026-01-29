terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }

  # Uncomment after bootstrap is applied and update with your values
 backend "azurerm" {
   resource_group_name  = "rg-panic-terraform-state"
   storage_account_name = "stpanicdevtfstateezdbi9"
   container_name       = "tfstate"
   key                  = "monitoring/prerequisites.tfstate"
 }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "monitoring" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    managed-by = "terraform"
    purpose    = "monitoring"
  }
}

resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days

  tags = {
    managed-by = "terraform"
    purpose    = "monitoring"
  }
}

resource "azurerm_monitor_action_group" "critical" {
  name                = var.action_group_critical_name
  resource_group_name = azurerm_resource_group.monitoring.name
  short_name          = "critical"

  dynamic "email_receiver" {
    for_each = var.critical_email_receivers
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email
      use_common_alert_schema = true
    }
  }

  tags = {
    managed-by = "terraform"
    severity   = "critical"
  }
}

resource "azurerm_monitor_action_group" "warning" {
  name                = var.action_group_warning_name
  resource_group_name = azurerm_resource_group.monitoring.name
  short_name          = "warning"

  dynamic "email_receiver" {
    for_each = var.warning_email_receivers
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email
      use_common_alert_schema = true
    }
  }

  tags = {
    managed-by = "terraform"
    severity   = "warning"
  }
}
