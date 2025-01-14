To use this solution, follow these steps in order:

- Clone the repository
- Navigate to the path for the solution (e.g. for MySQL, this path is "Solutions-as-Code/modules/MySql")
- Update the "main.tfvars" with the appropriate variables

        vsphere_server = "" - vcenter name or IP
        vsphere_user = ""   - vcenter admin user
        osguest_id = ""  - rhel8_64Guest for RedHat8
        internal_domain = "" - domain name eg puretec.purestorage.com.
        vmSubnet = "" - network VLAN eg VLAN2152
        dns_servers = ["", ""] - list of DNS servers
        vm_cluster = "se-shared-test-pod"  - Vcenter cluster name 
        dc = ""  - Vcenter data center name
        vm_gateway = "" - Gateway for the VM
        vm_count = "1"  - no of VMs to build
        vm_name = "mysql-vm"   - VM name. number will be appended to the name
        network = "10.21.152.0"  - network subnet for the VM
        netmask = "24"              - network subnet mask for the VM
        vm_ip = ["10.21.152.165"]  - list of IPs to be used for the VMs. 
        vmware_os_template = "rhel8_packer11082022"  - VM template to use.
        vm_cpus = 16        - no of cpus for the VM
        vm_memory = 16384       - Memory for the VM
        os_disk_size = "100"     - Size of OS disk
        data_disk_size = "10"    - Size of the additional disk
        datastore_os = "Template"    - Datastore to use for OS disk
        datastore_data = "Template"  - Datastore to use for Data disk



- Commit the changes and push to Git. 
- Log in to Jenkins (http://10.21.236.171:8080/). 
- Ensure the VCenter password has been saved under Jenkins credentials. You may need to create a new entry under Jenkins credentials for new VC as secret text and select this credential when running the build. If you created the vcenter credential with ID as 'vc2', you need to select 'vc2' when building the solution. 
- Select the project (Solution-automation) and click on 'Build with Parameters'. 
- Select the solution to build and test (e.g. MySQL) and select options to run such as build, install, test, and destroy.



How to Contribute
This section covers the steps for onboarding a new solution under this framework. This includes creating a Terraform module and Ansible playbook/roles for the solution. 
To create a new Terraform module for the solution, follow these steps in order:
- Clone the repository.
- Create a new directory (this can be the name of the solution) for the solution under the modules directory. If you are using the same platform as an existing solution, copy the existing folder and rename the directory accordingly. E.g. `cp -pr Solutions-as-Code/modules/MySql Solutions-as-Code/modules/postgresql`.
- Update the `Jenkinsfile` to include the new solution by updating the following line:
        `choice(choices: ['MySql','MSSQL','Oracle', 'Veem'], description: 'Select the Solution to build', name: 'solution')`

Follow the steps in the specified order to add Ansible playbooks/roles::
- Create a new role under the Ansible roles directory (Solutions-as-Code/ansible/roles/) to install the application or database for the solution. 
- Roles should follow the naming standards; for example, if you are creating new roles for PostgreSQL, it should need two main roles:
        - `postresql-install` - this includes the tasks to install and configure Postresql. 
        - `postgresql-test` - this includes the tasks to test the solution.
        - `postgresql-exporter` - this includes the tasks to install and configure the Prometheus exporter for Postresql.

        

Oracle install 

export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.6

remount /tmp without noexec