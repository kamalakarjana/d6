terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Configure in GitHub Actions
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatestorage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "vm_instance" {
  source = "./modules/vm"

  location              = var.location
  resource_group_name   = var.resource_group_name
  vm_name               = var.vm_name
  vm_size               = var.vm_size
  admin_username        = var.admin_username
  ssh_public_key        = var.ssh_public_key
  subnet_id             = var.subnet_id
  allowed_ssh_cidr      = var.allowed_ssh_cidr
  install_docker        = var.install_docker
  install_nginx         = var.install_nginx
}
