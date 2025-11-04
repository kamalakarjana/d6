# Azure VM with Docker and Nginx - Terraform

This project automates the deployment of an Azure VM with Docker and Nginx using Terraform and GitHub Actions.

## Prerequisites

1. Azure Service Principal with Contributor role
2. SSH key pair
3. Existing VNet and Subnet

## GitHub Secrets Required

- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET` 
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`
- `SSH_PRIVATE_KEY`

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Update the variables in `terraform.tfvars`
3. Push to main branch to trigger deployment

## Verification

After deployment:
- SSH: `ssh azureuser@<public-ip>`
- Web: `http://<public-ip>`
- Docker: `docker --version`
