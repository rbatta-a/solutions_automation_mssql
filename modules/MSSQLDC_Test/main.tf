module "vm" {
    source = "../basemodule-windows-withdomain"
    vmware_os_template               = var.vmware_os_template
    osguest_id                       = var.osguest_id
    internal_domain                  = var.internal_domain
    gateway                          = var.vm_gateway
    vmSubnet                         = var.vmSubnet
    network                          = var.network
    netmask                          = var.netmask
    vm_name                          = var.vm_name
    vm_count                         = var.vm_count 
    os_disk_size                     = var.os_disk_size
    vm_cpus                          = var.vm_cpus
    vm_memory                        = var.vm_memory
    dns_servers                      = var.dns_servers
    cluster                          = var.vm_cluster
    ip                               = var.vm_ip
    data_disk_size                   = var.data_disk_size
    datastore_os                     = var.datastore_os
    datastore_data                   = var.datastore_data
    dc                               = var.dc
    winadminpass                     = var.winadminpass
    contentlib_name                  = var.contentlib_name
    ansible_key                      = var.ansible_key

}
