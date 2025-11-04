terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "production"
    project     = "docker-nginx"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "main" {
  name                = "${var.vm_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = "production"
  }
}

# Create subnet
resource "azurerm_subnet" "main" {
  name                 = "${var.vm_name}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "vm_instance" {
  source = "./modules/vm"

  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  vm_name               = var.vm_name
  vm_size               = var.vm_size
  admin_username        = var.admin_username
  ssh_public_key        = var.ssh_public_key
  subnet_id             = azurerm_subnet.main.id
  allowed_ssh_cidr      = var.allowed_ssh_cidr
  install_docker        = var.install_docker
  install_nginx         = var.install_nginx
}
