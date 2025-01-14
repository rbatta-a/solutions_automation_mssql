

vsphere_server = "vcenter-shared.puretec.purestorage.com"
vsphere_user = "administrator@vsphere.local"
vsphere_password = ""

#common
osguest_id = "rhel8_64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "VLAN-2210"
dns_servers = ["10.21.210.98"]
vm_cluster = "Shared Cluster"
dc = "Shared Management Cluster"

vm_gateway = "10.21.210.1"


#vm 
vm_count = "1"
vm_name = "mysql"
network = "10.21.210.0"
netmask = "24"
vm_ip = ["10.21.210.22"]
#vmware_os_template = "linux-rocky-8-v24.09"
#vmware_os_template = "linux-ubuntu-22.04-lts-v23.01"
vmware_os_template = "linux-rhel-8-v23.07"
#vm_cpus = 32
vm_cpus = 4
vm_memory = 65536
os_disk_size = "100"
data_disk_size = "1500"
datastore_os = "sn1-x70-d08-21-vm-infra-vol"
datastore_data = "sn1-x70-d08-21-vm-infra-vol"
contentlib_name = "Shared-vCenter-ContentLib"












