terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.72.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "2.22.1"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "=1.6.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }

  }

}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "tls" {}