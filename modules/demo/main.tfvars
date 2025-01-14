

vsphere_server = "flashstack-vcenter.puretec.purestorage.com"
vsphere_user = "administrator@vsphere.local"
vsphere_password = ""

#common
osguest_id = "ubuntu64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "2210"
dns_servers = ["10.21.93.16"]
vm_cluster = "MetroCluster1"
dc = "SolutionsLab"

vm_gateway = "10.21.210.1"


#vm 
vm_count = "2"
vm_name = "demo"
network = "10.21.210.0"
netmask = "24"
vm_ip = ["10.21.210.22"]
vmware_os_template = "linux-ubuntu-22.04lts-v24.02"
vm_cpus = 12
vm_memory = 100000
os_disk_size = "100"
data_disk_size = "500"
datastore_os = "Metro_Cluster1_Prod01"
datastore_data = "Metro_Cluster1_Prod01"
contentlib_name = "SolutionsLab-ContentLib"












