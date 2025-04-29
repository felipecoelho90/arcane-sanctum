# Arcane Sanctum

A Terraform project for provisioning Oracle Cloud Infrastructure (OCI) resources.

## Overview

This project sets up a complete infrastructure in OCI, including:
- Virtual Cloud Network (VCN)
- Subnet
- Compute instances
- Security configurations

## Prerequisites

- Oracle Cloud Infrastructure account
- Terraform installed
- OCI CLI configured with API key

## Configuration

1. Copy the example variables file:
   ```bash
   cp oci/terraform.tfvars.example oci/terraform.tfvars
   ```

2. Update the variables in `terraform.tfvars` with your values:
   - Project configuration (project_name, environment)
   - OCI credentials (tenancy_ocid, user_ocid, fingerprint, private_key_path)
   - Network configuration (vcn_cidr, subnet_cidr)
   - VM configuration (vm_count, vm_shape, vm_ocpus, vm_memory_in_gbs, vm_name_prefix)
   - Security configuration (ssh_public_key_content, allowed_ssh_ips)

## Usage

1. Initialize Terraform:
   ```bash
   cd oci
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. To destroy the infrastructure:
   ```bash
   terraform destroy
   ```

## Variables

### Project Configuration
- `project_name`: Name of the project, used for resource naming and tagging
- `environment`: Environment name (e.g., dev, prod)

### OCI Credentials
- `tenancy_ocid`: OCID of your tenancy
- `user_ocid`: OCID of the user calling the API
- `fingerprint`: Fingerprint for the key pair being used
- `private_key_path`: Path to the private key file
- `region`: OCI region

### Network Configuration
- `vcn_cidr`: CIDR block for the VCN
- `subnet_cidr`: CIDR block for the subnet

### VM Configuration
- `vm_count`: Number of VMs to create
- `vm_shape`: Shape of the VM instance
- `vm_ocpus`: Number of OCPUs for the VM
- `vm_memory_in_gbs`: Amount of memory in GBs for the VM
- `vm_name_prefix`: Base name for the VM instances

### Operating System
- `operating_system`: Operating system for the VM
- `operating_system_version`: Version of the operating system

### Security Configuration
- `ssh_public_key_content`: Content of the SSH public key for VM access
- `allowed_ssh_ips`: Map of IP addresses to their descriptions for SSH access
- `enable_https`: Whether to enable HTTPS access
