variable "location" {
  description = "Azure region"
  type        = string
  default     = "South Africa North"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "docker-nginx-africa-rg"
}

variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
  default     = "docker-nginx-vm"
}

variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM authentication"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH to the VM"
  type        = string
  default     = "0.0.0.0/0"
}

variable "install_docker" {
  description = "Whether to install Docker on the VM"
  type        = bool
  default     = true
}

variable "install_nginx" {
  description = "Whether to install Nginx on the VM"
  type        = bool
  default     = true
}
