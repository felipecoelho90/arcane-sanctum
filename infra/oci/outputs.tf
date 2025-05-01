output "vm_details" {
  description = "Details of the VMs including names and public IPs"
  value = {
    for idx, instance in oci_core_instance.instance :
    instance.display_name => {
      name      = instance.display_name
      public_ip = instance.public_ip
    }
  }
} 