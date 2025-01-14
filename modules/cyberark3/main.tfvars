

vsphere_server = "flashstack-vcenter.puretec.purestorage.com"
vsphere_user = "administrator@vsphere.local"
vsphere_password = ""

#common
osguest_id = "windows9Server64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "2210"
dns_servers = ["10.21.210.98"]
vm_cluster = "MetroCluster1"
dc = "SolutionsLab"

vm_gateway = "10.21.210.1"


#vm 
vm_count = "1"
vm_name = "cyberark-second"
network = "10.21.210.0"
netmask = "24"
vm_ip = ["10.21.210.22"]
vmware_os_template = "windows-server-2022-standard-core-v23.07"
vm_cpus = 16
vm_memory = 16384
os_disk_size = "150"
data_disk_size = "500"
datastore_os = "Metro_Cluster1_Prod01"
datastore_data = "Metro_Cluster1_Prod01"
winadminpass = "VMware1!"
contentlib_name = "SolutionsLab-ContentLib"
vm_folder = "Unni-VMs"








