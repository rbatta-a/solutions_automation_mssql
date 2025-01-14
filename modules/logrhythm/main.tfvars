

vsphere_server = "flashstack-vcenter.puretec.purestorage.com"
vsphere_user = "administrator@vsphere.local"
vsphere_password = ""

#common
osguest_id = "windows2019srv_64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "2210"
dns_servers = ["10.21.210.28"]
vm_cluster = "MetroCluster1"
dc = "SolutionsLab"

vm_gateway = "10.21.210.1"


#vm 
vm_count = "1"
vm_name = "logrhythm"
network = "10.21.210.0"
netmask = "24"
vm_ip = ["10.21.210.22"]
vmware_os_template = "windows-server-2019-standard-core-v23.07"
vm_cpus = 32
vm_memory = 65536
os_disk_size = "300"
data_disk_size = "600"
datastore_os = "vvOLs-Metro"
datastore_data = "vvOLs-Metro"
winadminpass = "VMware1!"
contentlib_name = "SolutionsLab-ContentLib"








