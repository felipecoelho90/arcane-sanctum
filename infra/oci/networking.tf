# Virtual Cloud Network
resource "oci_core_vcn" "vcn" {
  compartment_id = oci_identity_compartment.project.id
  display_name   = "${var.project_name}-vcn"
  cidr_block     = var.vcn_cidr
  dns_label      = replace(var.project_name, "-", "")

  freeform_tags = local.common_tags
}

# Internet Gateway
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = oci_identity_compartment.project.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-igw"
  enabled        = true

  freeform_tags = local.common_tags
}

# Route Table
resource "oci_core_route_table" "route_table" {
  compartment_id = oci_identity_compartment.project.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }

  freeform_tags = local.common_tags
}

# Security List
resource "oci_core_security_list" "security_list" {
  compartment_id = oci_identity_compartment.project.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-sl"

  # Allow SSH from specific IPs
  dynamic "ingress_security_rules" {
    for_each = var.allowed_ssh_ips
    content {
      protocol    = "6"
      source      = "${ingress_security_rules.key}/32"
      description = "Allow SSH from ${ingress_security_rules.value}"
      tcp_options {
        min = 22
        max = 22
      }
    }
  }

  # Allow HTTPS from anywhere if enabled
  dynamic "ingress_security_rules" {
    for_each = var.enable_https ? [1] : []
    content {
      protocol    = "6"
      source      = "0.0.0.0/0"
      description = "Allow HTTPS from anywhere"
      tcp_options {
        min = 443
        max = 443
      }
    }
  }

  # Allow all outbound traffic
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Allow all outbound traffic"
  }

  freeform_tags = local.common_tags
}

# Subnet
resource "oci_core_subnet" "subnet" {
  compartment_id = oci_identity_compartment.project.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.project_name}-subnet"
  cidr_block     = var.subnet_cidr
  dns_label      = "subnet"
  route_table_id = oci_core_route_table.route_table.id
  security_list_ids = [oci_core_security_list.security_list.id]

  freeform_tags = local.common_tags
} 