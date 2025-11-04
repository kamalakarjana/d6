output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = module.vm_instance.vm_public_ip
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = module.vm_instance.vm_private_ip
}

output "ssh_connection_command" {
  description = "SSH connection command"
  value       = module.vm_instance.ssh_connection_command
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Virtual network name"
  value       = azurerm_virtual_network.main.name
}
