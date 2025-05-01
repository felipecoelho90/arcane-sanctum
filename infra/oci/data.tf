# Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Ubuntu Image
data "oci_core_images" "ubuntu" {
  compartment_id           = oci_identity_compartment.project.id
  operating_system         = var.operating_system
  operating_system_version = var.operating_system_version
  shape                   = var.vm_shape
  state                   = "AVAILABLE"
  sort_by                 = "TIMECREATED"
  sort_order              = "DESC"
} 