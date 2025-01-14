terraform {
  required_providers {

    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.1.1"
    }

    infoblox = {
    source = "infobloxopen/infoblox"
    version = "2.3.0"
    }
  }
}


## Build VM
data "vsphere_datacenter" "datacenter" {
  name = var.dc
}

data "vsphere_datastore" "datastore_os" {
  name = var.datastore_os 
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore_data" {
  name = var.datastore_data
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.cluster}/Resources"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vmSubnet 
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# data "vsphere_virtual_machine" "template" {
#   name = var.vmware_os_template
#   datacenter_id = data.vsphere_datacenter.datacenter.id
# }
data "vsphere_content_library" "my_content_library" {
  name = var.contentlib_name
}

data "vsphere_content_library_item" "my_ovf_item" {
  name       = var.vmware_os_template
  type       = "ovf"
  library_id = data.vsphere_content_library.my_content_library.id
}

resource "infoblox_ip_allocation" "alloc1" {
  count = var.vm_count
  network_view="default"
  #cidr = var.network + "/" + var.netmask
  ipv4_cidr = format("%s/%s",var.network,var.netmask)
                       
  dns_view="INTERNAL" # may be commented out
  fqdn=format("%s-%d.%s",var.vm_name,count.index +1,var.internal_domain)
  enable_dns = "true"
  comment = "Allocating an IPv4 address"
}

resource "vsphere_virtual_machine" "vm" {
  #depends_on = infoblox
  count            = var.vm_count
  name    = trimsuffix( format("%s-%d.${var.internal_domain}",var.vm_name,count.index +1),"." )
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore_os.id
  num_cpus = var.vm_cpus
  memory   = var.vm_memory
  num_cores_per_socket = 2
  sync_time_with_host = true
  guest_id = var.osguest_id 
  firmware = "efi"
  scsi_controller_count = 4

  network_interface {
    network_id   = data.vsphere_network.network.id
  }
  # disk {
  #   label = "BOOT-DISK"
  #   unit_number = 0 
  #   size  = 2

  #   #eagerly_scrub = true

  # }
  disk {
    label = "OS-DISK"
    unit_number = 0
    size  = var.os_disk_size


  }

  disk {
    label = "DATA-DISK1"
    size        = var.data_disk_size
    datastore_id = data.vsphere_datastore.datastore_data.id
    unit_number = 14
  }
  
  disk {
    label = "DATA-DISK2"
    size        = 2000
    datastore_id = data.vsphere_datastore.datastore_data.id
    unit_number = 15
  }
  disk {
    label = "DATA-DISK3"
    size        = 500
    datastore_id = data.vsphere_datastore.datastore_data.id
    unit_number = 30
  }
  disk {
    label = "DATA-DISK4"
    size        = 500
    datastore_id = data.vsphere_datastore.datastore_data.id
    unit_number = 45
  }


  clone {
    
    #template_uuid = data.vsphere_virtual_machine.template.id
    template_uuid = data.vsphere_content_library_item.my_ovf_item.id
    customize {
      linux_options {
        
        host_name = format("%s-%d", var.vm_name ,count.index +1)
        domain    = "puretec.purestorage.com"   #trimsuffix( var.internal_domain, "." ) 
      }
      network_interface {

        ipv4_address = infoblox_ip_allocation.alloc1[count.index].allocated_ipv4_addr
        #ipv4_address = var.ip[count.index]
        ipv4_netmask = var.netmask
      }
       ipv4_gateway    = var.gateway
       dns_suffix_list = [var.internal_domain]
       dns_server_list = var.dns_servers
    }
  }

  provisioner "file" {
    source = "scripts/resizefs.sh"
    destination = "/home/ansible/resizefs.sh"
    
  }
  connection {
    type     = "ssh"
    user     = "ansible"
    #private_key = file("/var/lib/jenkins/ansible.key")
    private_key = file(var.ansible_key)
    host     = self.default_ip_address
    script_path = "/home/ansible/tmp_resizefs.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -x",
      "chmod +x /home/ansible/*sh",
      "sudo sh /home/ansible/resizefs.sh"
    ]
  }

  # provisioner "local-exec" {
  #   command = "ansible-playbook -i ${vsphere_virtual_machine.vm[count.index].default_ip_address}, --private-key ~/ansible.key --user ansible ../../ansible/playbooks/common.yml"
  # }
  
  # provisioner "local-exec" {
  #   command = "ansible-playbook -i ${vsphere_virtual_machine.vm[count.index].default_ip_address}, --private-key ~/ansible.key --user ansible ../../ansible/playbooks/mysql.yml"
  # }
}


