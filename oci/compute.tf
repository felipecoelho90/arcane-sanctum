locals {
  vm_config = {
    shape = "VM.Standard.E2.1.Micro"  # Always Free shape
    shape_config = {
      ocpus         = 1
      memory_in_gbs = 1
    }
  }
}

# Create VM Instances
resource "oci_core_instance" "instance" {
  count               = 1
  compartment_id      = oci_identity_compartment.arcane_sanctum.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape               = local.vm_config.shape
  display_name        = "oci-ubuntu-${format("%02d", count.index + 1)}"

  shape_config {
    ocpus         = local.vm_config.shape_config.ocpus
    memory_in_gbs = local.vm_config.shape_config.memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    display_name     = "primary-vnic-${count.index + 1}"
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key_content
    user_data          = base64encode(templatefile("${path.module}/cloud-init-docker.yaml", {
      ssh_public_key_content = var.ssh_public_key_content
      hostname              = "oci-ubuntu-${format("%02d", count.index + 1)}"
    }))
  }
} 