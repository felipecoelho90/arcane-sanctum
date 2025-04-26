# Get Ubuntu image
data "oci_core_images" "ubuntu" {
  compartment_id           = oci_identity_compartment.arcane_sanctum.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04 Minimal"
  shape                   = "VM.Standard.E2.1.Micro"
  state                   = "AVAILABLE"
  sort_by                 = "TIMECREATED"
  sort_order              = "DESC"
}

# Get availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
} 