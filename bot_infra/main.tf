terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.39.0"
    }
  }
}
  # Terraform Cloud backend configuration - commented out for local development
  # backend "remote" {
  #   organization = "Corratech"
  #
  #   workspaces {
  #     name = "az-cs-bot"
  #   }
  # }

provider "azurerm" {
  subscription_id = "eba1207e-c9f6-42ee-bfe7-ab894a3f14ce"
  tenant_id = "28609860-e5ad-45f1-9ef7-9569113e5e06"
  features {}
}

provider "azuread" {}

module "customer_service_bot" {
  source              = "./modules/customer_service_bot"
  resource_group_name = var.resource_group_name
  location            = var.location
  bot_name            = var.bot_name
}