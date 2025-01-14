

vsphere_server = "vcenter-shared.puretec.purestorage.com"
vsphere_user = "administrator@vsphere.local"
vsphere_password = ""

#common
osguest_id = "ubuntu64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "VLAN-2210"
dns_servers = ["10.21.210.98"]
vm_cluster = "Shared Cluster"
dc = "Shared Management Cluster"

vm_gateway = "10.21.210.1"


#vm 
vm_count = "1"
vm_name = "cowriter"
network = "10.21.210.0"
netmask = "24"
vm_ip = ["10.21.210.22"]
vmware_os_template = "linux-ubuntu-22.04lts-v24.02"
vm_cpus = 16
vm_memory = 16384
os_disk_size = "100"
data_disk_size = "500"
datastore_os = "sn1-x70-d08-21-vm-infra-vol"
datastore_data = "sn1-x70-d08-21-vm-infra-vol"
contentlib_name = "Shared-vCenter-ContentLib"












