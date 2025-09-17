
terraform {
  # An arbitrary constraint on the version of Terraform or OpenTofu used:
  required_version = ">= 1.9.0"

  # If using remote state, we define the backend storage here:
  #backend "azurerm" { features {} }

  # Specifying versions of Provider plugins to use:
  required_providers {
    # AzApi is an alternate provider for experimental Azure Resources:
    azapi = {
      source  = "azure/azapi"
      version = ">=1.8"
    }

    # Azurerm Provider version to use (best to use latest for AKS use):
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.27"
    }

    random = {
      source  = "hashicorp/random"
      version = ">=3.5"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  features {}

  # NOTE: we do not need to specify this argument because
  #       env variable ARM_SUBSCRIPTION_ID is set in the shell
  #subscription_id = var.subscription_id
}

