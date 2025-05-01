# Object Storage Bucket
resource "oci_objectstorage_bucket" "bucket" {
  compartment_id = oci_identity_compartment.project.id
  name           = var.project_name
  access_type    = "NoPublicAccess"
  versioning     = "Disabled"
  namespace      = data.oci_objectstorage_namespace.ns.namespace
}

# Get the namespace
data "oci_objectstorage_namespace" "ns" {
  compartment_id = oci_identity_compartment.project.id
}

# Policy to allow access from VMs and specified IPs
resource "oci_identity_policy" "bucket_access_policy" {
  compartment_id = var.tenancy_ocid
  name           = "${var.project_name}-bucket-access-policy"
  description    = "Policy to allow access to the bucket from VMs and specified IPs"
  statements = [
    "Allow group ${oci_identity_group.vm_group.name} to manage objects in compartment ${oci_identity_compartment.project.name} where all {target.bucket.name='${var.project_name}'}",
    "Allow group ${oci_identity_group.vm_group.name} to read objects in compartment ${oci_identity_compartment.project.name} where all {target.bucket.name='${var.project_name}'}"
  ]
}

# Group for VM instances
resource "oci_identity_group" "vm_group" {
  compartment_id = var.tenancy_ocid
  name           = "${var.project_name}-vm-group"
  description    = "Group for VM instances that need access to the bucket"
}

# Add VMs to the group
resource "oci_identity_user_group_membership" "vm_group_membership" {
  count = var.vm_count
  group_id = oci_identity_group.vm_group.id
  user_id  = oci_identity_user.vm_user[count.index].id
}

# Create users for each VM
resource "oci_identity_user" "vm_user" {
  count = var.vm_count
  compartment_id = var.tenancy_ocid
  name           = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}-user"
  description    = "User for VM instance ${count.index + 1}"
  email          = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}-user@${var.vm_user_email_domain}"
}

# Create API keys for each VM user
resource "oci_identity_api_key" "vm_api_key" {
  count = var.vm_count
  user_id = oci_identity_user.vm_user[count.index].id
  key_value = tls_private_key.vm_key[count.index].public_key_pem
}

# Generate private keys for VM users
resource "tls_private_key" "vm_key" {
  count = var.vm_count
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store the private keys in the bucket
resource "oci_objectstorage_object" "vm_private_key" {
  count = var.vm_count
  bucket    = oci_objectstorage_bucket.bucket.name
  namespace = data.oci_objectstorage_namespace.ns.namespace
  object    = "vm-keys/${var.vm_name_prefix}-${format("%02d", count.index + 1)}-private-key.pem"
  content   = tls_private_key.vm_key[count.index].private_key_pem
} 