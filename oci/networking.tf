# Create VCN
resource "oci_core_vcn" "vcn" {
  compartment_id = oci_identity_compartment.arcane_sanctum.id
  display_name   = "arcane-sanctum-vcn"
  cidr_block     = "10.0.0.0/16"
  dns_label      = "arcanesanctum"
}

# Create Internet Gateway
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = oci_identity_compartment.arcane_sanctum.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "arcane-sanctum-igw"
  enabled        = true
}

# Create Route Table
resource "oci_core_route_table" "route_table" {
  compartment_id = oci_identity_compartment.arcane_sanctum.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "arcane-sanctum-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

# Create Subnet
resource "oci_core_subnet" "subnet" {
  compartment_id = oci_identity_compartment.arcane_sanctum.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "arcane-sanctum-subnet"
  cidr_block     = "10.0.1.0/24"
  dns_label      = "subnet"
  route_table_id = oci_core_route_table.route_table.id
  security_list_ids = [oci_core_security_list.security_list.id]
}

# Create Security List
resource "oci_core_security_list" "security_list" {
  compartment_id = oci_identity_compartment.arcane_sanctum.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "arcane-sanctum-sl"

  # Allow SSH only from specific IP
  ingress_security_rules {
    protocol    = "6"
    source      = "${var.allowed_ip}/32"
    description = "Allow SSH from specific IP"
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Allow HTTP from anywhere
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Allow HTTP from anywhere"
    tcp_options {
      min = 80
      max = 80
    }
  }

  # Allow HTTPS from anywhere
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Allow HTTPS from anywhere"
    tcp_options {
      min = 443
      max = 443
    }
  }

  # Allow all outbound traffic
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Allow all outbound traffic"
  }
} 