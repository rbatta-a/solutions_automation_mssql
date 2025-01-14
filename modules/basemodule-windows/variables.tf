
variable "vm_count" {
  type        = string
  description = "Number of VM"
  default     =  1
}
variable "vm_name" {
  type        = string
  description = "Name of VM"
}

variable "network" {}
variable "netmask"  {}
variable "vmware_os_template" {}
variable "vm_cpus" {}
variable "vm_memory" {}
variable "cluster" {}
variable "ip" {}
variable "dns_servers" {
  type = list
}
variable "osguest_id" {}
variable "internal_domain" {}
variable "gateway" {}
variable "vmSubnet" {}
variable "os_disk_size" {}
variable "data_disk_size" {}
#variable "data_disk2_size" {}
variable "datastore_os" {}
variable "datastore_data" {}
variable "datastore_data2" {}
variable "dc" {
  
}
variable "winadminpass" {
  
}
variable "ansible_key" {}
variable "contentlib_name" {
  
}