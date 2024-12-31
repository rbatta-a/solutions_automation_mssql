

vsphere_server = "flashstack-vcenter.puretec.purestorage.com"
vsphere_user = "administrator@vsphere.local"
vsphere_password = ""

#common
osguest_id = "rhel8_64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "2210"
dns_servers = ["10.21.93.16"]
vm_cluster = "MetroCluster1"
dc = "SolutionsLab"

vm_gateway = "10.21.210.1"


#vm 
vm_count = "1"
vm_name = "postgres"
network = "10.21.210.0"
netmask = "24"
vm_ip = ["10.21.210.165"]
vmware_os_template = "linux-rhel-8-v23.07"
vm_cpus = 16
vm_memory = 16384
os_disk_size = "100"
data_disk_size = "100"
datastore_os = "vvOLs-Metro"
datastore_data = "vvOLs-Metro"
contentlib_name = "SolutionsLab-ContentLib"












