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

variable "ssh_public_key_content" {
  description = "Content of the SSH public key for VM access"
  type        = string
}

variable "allowed_ip" {
  description = "Your IP address to allow SSH, HTTP, and HTTPS access"
  type        = string
} 