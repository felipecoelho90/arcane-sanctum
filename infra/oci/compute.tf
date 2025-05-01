# VM Configuration
locals {
  vm_config = {
    shape = var.vm_shape
    shape_config = {
      ocpus         = var.vm_ocpus
      memory_in_gbs = var.vm_memory_in_gbs
    }
  }
}

# VM Instances
resource "oci_core_instance" "instance" {
  count               = var.vm_count
  compartment_id      = oci_identity_compartment.project.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape               = local.vm_config.shape
  display_name        = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"

  shape_config {
    ocpus         = local.vm_config.shape_config.ocpus
    memory_in_gbs = local.vm_config.shape_config.memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    display_name     = "primary-vnic-${count.index + 1}"
    assign_public_ip = true
    hostname_label   = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images[0].id
  }

  metadata = {
    ssh_authorized_keys      = var.ssh_public_key_content
    user_data                = base64encode(templatefile("${path.module}/cloud-init-docker.yaml", {
      ssh_public_key_content = var.ssh_public_key_content
      hostname               = "${var.vm_name_prefix}-${format("%02d", count.index + 1)}"
    }))
  }

  freeform_tags = local.common_tags
} 