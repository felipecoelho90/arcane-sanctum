# Provider Configuration
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# Common Configuration
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Compartment
resource "oci_identity_compartment" "project" {
  name          = var.project_name
  description   = "Compartment for ${var.project_name} resources"
  enable_delete = true

  freeform_tags = local.common_tags
} 