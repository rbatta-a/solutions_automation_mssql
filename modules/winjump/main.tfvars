

vsphere_server = "vcenter-shared.puretec.purestorage.com"
vsphere_user = "administrator@vsphere.local"
vsphere_password = ""

#common
osguest_id = "windows9Server64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "VLAN-2210"
dns_servers = ["10.21.93.16"]
vm_cluster = "Shared Cluster"
dc = "Shared Management Cluster"

vm_gateway = "10.21.210.1"


#vm 
vm_count = "2"
vm_name = "win-jump"
network = "10.21.210.0"
netmask = "24"
vm_ip = ["10.21.210.22"]
vmware_os_template = "windows-server-2022-standard-core-v23.07"
vm_cpus = 16
vm_memory = 16384
os_disk_size = "100"
data_disk_size = "500"
datastore_os = "sn1-x70-d08-21-vm-infra-vol"
datastore_data = "sn1-x70-d08-21-vm-infra-vol"
winadminpass = "VMware1!"
contentlib_name = "Shared-vCenter-ContentLib"
vm_folder = "Unni-VMs"








