

vsphere_server = "flashstack-vcenter.puretec.purestorage.com"
vsphere_user = "administrator@vsphere.local"
vsphere_password = ""

#common
osguest_id = "windows9Server64Guest"
internal_domain = "puretec.purestorage.com"
vmSubnet = "MGMT_2210"
dns_servers = ["10.21.210.28"]
vm_cluster = "MetroCluster1"
dc = "SolutionsLab"

vm_gateway = "10.21.210.1"


#vm 
vm_count = "1"
vm_name = "sizer-mssql-x"
network = "10.21.210.0"
netmask = "24"
vm_ip = ["10.21.210.22"]
vmware_os_template = "windows-server-2022-standard-core-v23.07"
vm_cpus = 8
vm_memory = 16384
os_disk_size = "200"
data_disk_size = "1024"
datastore_os = "vvOLs-Metro"
datastore_data = "vvOLs-Metro"
datastore_data2 = "vvOLs-Metro"
#These below are the original aspects present and we added from the MSSQLDC  the above datastaore_os and datastore_data
#datastore_os = "Metro_Cluster1_Prod01"
#datastore_data = "sql-sizer-data"
#datastore_data2 = "sql-sizer-log"
winadminpass = "VMware1!"
contentlib_name = "SolutionsLab-ContentLib"








