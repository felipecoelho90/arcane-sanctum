# Project Configuration
variable "project_name" {
  description = "Name of the project, used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "production"
}

# OCI Credentials
variable "tenancy_ocid" {
  description = "OCID of your tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCID of the user calling the API"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint for the key pair being used"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
}

variable "region" {
  description = "OCI region"
  type        = string
  default     = "eu-amsterdam-1"
}

# Network Configuration
variable "vcn_cidr" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# VM Configuration
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}

variable "vm_shape" {
  description = "Shape of the VM instance"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "vm_ocpus" {
  description = "Number of OCPUs for the VM"
  type        = number
  default     = 1
}

variable "vm_memory_in_gbs" {
  description = "Amount of memory in GBs for the VM"
  type        = number
  default     = 1
}

# Operating System
variable "operating_system" {
  description = "Operating system for the VM"
  type        = string
  default     = "Canonical Ubuntu"
}

variable "operating_system_version" {
  description = "Version of the operating system"
  type        = string
  default     = "24.04"
}

# Security Configuration
variable "ssh_public_key_content" {
  description = "Content of the SSH public key for VM access"
  type        = string
}

variable "allowed_ssh_ips" {
  description = "Map of IP addresses to their descriptions for SSH access"
  type        = map(string)
  default     = {}
}

variable "enable_https" {
  description = "Whether to enable HTTPS access"
  type        = bool
  default     = true
} 