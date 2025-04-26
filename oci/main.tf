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

# Create a compartment
resource "oci_identity_compartment" "arcane_sanctum" {
  name          = "arcane-sanctum"
  description   = "Compartment for Arcane Sanctum resources"
  enable_delete = true
} 