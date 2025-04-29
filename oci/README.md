# Arcane Sanctum - OCI Infrastructure

This directory contains Terraform configurations to deploy a free tier virtual machine on Oracle Cloud Infrastructure (OCI) in the Amsterdam region.

## Infrastructure Overview

The infrastructure includes:
- A compartment named "arcane-sanctum" with proper tagging
- A Virtual Cloud Network (VCN) with a subnet
- An Internet Gateway for internet access
- A route table for routing traffic
- A security list allowing:
  - SSH (22) access from specific IP addresses with descriptive names
  - HTTPS (443) access from anywhere
- A VM instance using the always-free shape (VM.Standard.E2.1.Micro)
- Ubuntu 24.04 Minimal LTS as the operating system
- Docker and Docker Compose installed via cloud-init
- A dedicated docker user with sudo privileges
- Proper resource tagging for cost tracking and management

## Prerequisites

1. An Oracle Cloud Infrastructure (OCI) account
2. Terraform installed on your local machine
3. OCI CLI configured (optional, but recommended)
4. SSH key pair for VM access

## File Structure

```
oci/
├── main.tf           # Provider configuration, compartment, and common tags
├── variables.tf      # Variable definitions
├── networking.tf     # Network infrastructure (VCN, Subnet, etc.)
├── compute.tf        # VM instance configuration
├── data.tf           # Data sources (Ubuntu image, availability domains)
├── outputs.tf        # Output definitions
├── cloud-init-docker.yaml # Cloud-init configuration for Docker setup
└── terraform.tfvars  # Your OCI credentials (not in version control)
```

## Resource Tagging

All resources are tagged with:
- Project: "arcane-sanctum"
- Environment: "production"
- ManagedBy: "terraform"

These tags help with:
- Cost tracking
- Resource organization
- Access control
- Automation

## Setup Instructions

### 1. OCI Credentials

You need to gather the following information from your OCI Console:

1. **Tenancy OCID**:
   - Go to Administration > Tenancy Details
   - Copy the OCID value

2. **User OCID**:
   - Go to Identity > Users
   - Click on your user
   - Copy the OCID value

3. **API Key**:
   - Go to Identity > Users > Your User > API Keys
   - If you don't have an API key:
     - Click "Add API Key"
     - Choose "Generate API Key Pair"
     - Download the private key and save it to `~/.oci/oci_api_key.pem`
     - Copy the fingerprint value

### 2. SSH Key Setup

If you don't have an SSH key pair:
```bash
ssh-keygen -t rsa -b 2048
```
This will create:
- Private key: `~/.ssh/id_rsa`
- Public key: `~/.ssh/id_rsa.pub`

To get the content of your public key:
```bash
cat ~/.ssh/id_rsa.pub
```

### 3. Configuration

1. Copy the example variables file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edit `terraform.tfvars` with your actual values:
```hcl
tenancy_ocid        = "ocid1.tenancy.oc1..your_tenancy_ocid"
user_ocid           = "ocid1.user.oc1..your_user_ocid"
fingerprint         = "your_api_key_fingerprint"
private_key_path    = "~/.oci/oci_api_key.pem"
region              = "eu-amsterdam-1"
ssh_public_key_content = "ssh-rsa AAAA... your_public_key_content_here ..."

# Map of IP addresses to their descriptions for SSH access
allowed_ips = {
  "your.ip.address.1" = "Home Office"
  "your.ip.address.2" = "Work Office"
}
```

### 4. Deployment

1. Initialize Terraform:
```bash
terraform init
```

2. Review the planned changes:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

## Accessing the VM

After deployment, you can:
- SSH into the VM as the docker user:
  ```bash
  ssh docker@<vm-ip-address>
  ```
- The VM will be running:
  - Ubuntu 22.04 with 1 OCPU and 1GB of memory (always free tier)
  - Docker and Docker Compose installed
  - A docker user with sudo privileges
  - Hostname matching the VM name (oci-ubuntu-XX)
  - Proper DNS resolution with hostname_label

## Security Notes

- SSH access is restricted to specific IP addresses with descriptive names
- HTTPS is accessible from anywhere
- The VM is assigned a public IP address
- Make sure to keep your private keys secure and never commit them to version control
- All resources are properly tagged for security and compliance

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

## Support

For issues or questions, please contact the maintainers of this repository. 