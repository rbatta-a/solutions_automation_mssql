
variable "vsphere_user" {
  type        = string
  description = "vCenter/vSphere user"
}
variable "vsphere_password" {
  type        = string
  description = "Password for vCenter/vSphere user"
}
variable "vsphere_server" {
  type        = string
  description = "vCenter server or vSphere host name"
}


variable "vm_count" {
  type        = string
  description = "Number of VM"
  default     =  1
}
variable "vm_name" {
  type        = string
  description = "Name of VM"
}
variable "dns_servers" {
  
}
variable "os_disk_size" {}
variable "vmSubnet" {}
variable "vm_gateway" {}
variable "internal_domain" {}
variable "network" {}
variable "netmask"  {}
variable "vmware_os_template" {}
variable "vm_cpus" {}
variable "vm_memory" {}
variable "vm_cluster" {}
variable "vm_ip" {
  type = list
  
}

variable "osguest_id" {}
variable "data_disk_size" {
  
}
variable "datastore_os" {
  
}
variable "datastore_data" {
  
}
variable "datastore_data2" {
  
}
variable "dc" {
  
}
variable "winadminpass" {
  
}

variable "contentlib_name" {}

variable "ansible_key" {
  
}

variable "infoblox_pass" {
  
}
variable "vm_folder" {
  
}