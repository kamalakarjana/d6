variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM authentication"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the VM will be launched"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH to the VM"
  type        = string
}

variable "install_docker" {
  description = "Whether to install Docker on the VM"
  type        = bool
}

variable "install_nginx" {
  description = "Whether to install Nginx on the VM"
  type        = bool
}
