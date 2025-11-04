output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.vm.ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.vm.private_ip_address
}

output "ssh_connection_command" {
  description = "SSH connection command"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.vm.ip_address}"
}

output "resource_group_name" {
  description = "Resource group name"
  value       = var.resource_group_name
}
