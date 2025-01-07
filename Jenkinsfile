pipeline {
    agent any
    options {
        ansiColor('xterm')
    }
    parameters {
        choice(choices: ['MySql','MSSQL_Test','MSSQLDC_Test', 'Postgres', 'Oracle','spark-dev', 'Commvault', 'cyberark3', 'Oracle-demo','k8s', 'Oracle-rac', 'keerthi-ubuntu', 'data'], description: 'Select the Solution to build', name: 'solution')
        //choice(choices: ['cowriter','MySql','MSSQL', 'MSSQLDC', 'Postgres', 'Oracle','winjump','logrhythm','syslog','qradar','superna','superna-ubuntu', 'keerthi-ubuntu', 'util','k8s', 'Oracle-rac', 'splunk', 'superna-windows','superna-windows2','superna-windows3','superna-windows-19','akriti-ubuntu', 'linux-ubuntu', 'spark', 'cyberark', 'cyberark1', 'cyberark2', 'cyberark3', 'spark-dev', 'veeam-backup-and-replication','cyberark-pvwa', 'veeam'], description: 'Select the Solution to build', name: 'solution')
        string(name: 'count', defaultValue: "0", description: 'Number of VMs')
        choice(choices: ['fsvc', 'shared-vc'], description: 'Select the VC to use', name: 'vcenter')
        booleanParam(name: 'Build', defaultValue: false, description: 'Build Intrastructure')
        booleanParam(name: 'Install', defaultValue: false, description: 'Install and configure solution')
	    booleanParam(name: 'Test', defaultValue: false, description: 'Run the performance test')
	    booleanParam(name: 'Destroy', defaultValue: false, description: 'Destroy Intrastructure')
		
    }

    stages {
        stage('Build solution') {
            environment {
                SSH_KEY = credentials('ansible')
		WINDOWS_ADMIN_PASS = credentials('windows_admin_password')
                VC_PASS = credentials("${params.vcenter}")
                INFOBLOX_PASS = credentials('infoblox')
                AWS_ACCESS_KEY_ID = 'PSFBSAZRAECJNHNFJEKCPOHOOPMGMKMJLIJLKBCMLB'
                AWS_SECRET_ACCESS_KEY = credentials('s3token')
                ANSIBLE_HOST_KEY_CHECKING = "False"
                ANSIBLE_ROLES_PATH = "../../ansible/roles"
                vm_count = "${params.count}".toInteger()

		/** 
		* Veeam backup & replication Setup 
		*/
                VEEAM_SERV_WSDIR = "/var/lib/jenkins/workspace/Solution-automation/modules/veeam-server"
	        VEEAM_WINSERVS_WSDIR = "/var/lib/jenkins/workspace/Solution-automation/modules/veeam-windows-servers" 
      	        VEEAM_LINSERVS_WSDIR = "/var/lib/jenkins/workspace/Solution-automation/modules/veeam-linux-servers"
            }
            steps {
                
                script {
    		        sh "echo Hello from Build stage"
                    //sh 'echo ssh key from script section - ${SSH_KEY}'
    		        sol_name = params.solution
    		        build_solution(sol_name)
    	         }
                  }
        }
    }
}


  def build_solution(sol) {
    def tf_cmd = "/usr/bin/terraform"
	def workspace = pwd()
	println "workspace ------${workspace}-----"
	
	def solname = sol.trim()
	def path = workspace + "/" + "modules" + "/" + solname
	println "path ------${path}-----"
	dir(path) {
	if (params.Build) {
              if (solname == 'Veeam') {
		/**
		* Create the Veeams Clutser VMs
                */

		/** 
 		* Creating VMs for Veeam Installation
		*/
		dir("${VEEAM_SERV_WSDIR}") {
                  println  "Setting Veeam Server VM"
                  def vpath = workspace + "/" + "modules" + "/" + "veeam-server".trim()
		  echo "current working directory: ${pwd()}"
		  println "vpath ------${vpath}-----"
	 	  println "Updating backend file"
            	  sh script: "sed -i -e 's/sol_name/"+"veem-server"+"/g' backend.tf"
		  println "Executing Infrstructure build step" 
            	  sh script: "/bin/rm -rf .terraform"
	          print  "sh script: ${tf_cmd} init -upgrade"
	          sh script: "${tf_cmd} init -upgrade"
            	  count = sh(script: "grep vm_count main.tfvars | awk  '{print \$3}' |xargs", returnStdout: true)
            	  //count = sh(script: "cat hosts.ini|wc -l", returnStdout: true)
           	  println count
            	  println vm_count
            	  total_count = vm_count.toInteger() + count.toInteger()
            	  println total_count
		  sh script: "$tf_cmd apply -auto-approve -var-file=$vpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	 + " -var ansible_key=" + '${SSH_KEY}'	+	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'  +	" -var vm_count=" + total_count
            	  sh script: "python3.9 ../../build-inventory.py " + "veeam-server"
            	  sh script: "cat hosts.ini"
                }

		/** 
 		* Creating Windows VMs for Veeam Proxy & Repo
		*/
	       dir("${VEEAM_WINSERVS_WSDIR}") {
            	  println  "Creating: Windows Servers ..."
                  def vwpath = workspace + "/" + "modules" + "/" + "veeam-windows-servers".trim()
		  echo "current working directory: ${pwd()}"
		  println "vwpath ------${vwpath}-----"
	 	  println "Updating backend file"
            	  sh script: "sed -i -e 's/sol_name/"+"veeam-windows-servers"+"/g' backend.tf"
		  println "Executing Infrstructure build step" 
            	  sh script: "/bin/rm -rf .terraform"
	          print  "sh script: ${tf_cmd} init -upgrade"
	          sh script: "${tf_cmd} init -upgrade"
            	  count = sh(script: "grep vm_count main.tfvars | awk  '{print \$3}' |xargs", returnStdout: true)
            	  //count = sh(script: "cat hosts.ini|wc -l", returnStdout: true)
           	  println count
            	  println vm_count
            	  total_count = vm_count.toInteger() + count.toInteger()
            	  println total_count
		  sh script: "$tf_cmd apply -auto-approve -var-file=$vwpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	 + " -var ansible_key=" + '${SSH_KEY}'	+	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'  +	" -var vm_count=" + total_count
            	  sh script: "python3 ../../build-inventory.py " + "veeam-windows-servers"
            	  sh script: "cat hosts.ini"
	       }

		/** 
 		* Creating Linux VMs for Veeam Repo
		*/
	       dir("${VEEAM_LINSERVS_WSDIR}") {
            	  println  "Creating: Linux Servers ..."
                  def vlpath = workspace + "/" + "modules" + "/" + "veeam-linux-servers".trim()
        	  echo "Inside Dir: ${pwd()}"
		  println "vlpath ------${vlpath}-----"
	 	  println "Updating backend file"
            	  sh script: "sed -i -e 's/sol_name/"+"veeam-linux-servers"+"/g' backend.tf"
		  println "Executing Infrstructure build step" 
            	  sh script: "/bin/rm -rf .terraform"
	          print  "sh script: ${tf_cmd} init -upgrade"
	          sh script: "${tf_cmd} init -upgrade"
            	  count = sh(script: "grep vm_count main.tfvars | awk  '{print \$3}' |xargs", returnStdout: true)
            	  //count = sh(script: "cat hosts.ini|wc -l", returnStdout: true)
           	  println count
            	  println vm_count
            	  total_count = vm_count.toInteger() + count.toInteger()
            	  println total_count
		  sh script: "$tf_cmd apply -auto-approve -var-file=$vlpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	 + " -var ansible_key=" + '${SSH_KEY}'	+	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'  +	" -var vm_count=" + total_count
            	  sh script: "python3.6 ../../build-inventory.py " + "veeam-linux-servers"
            	  sh script: "cat hosts.ini"
	      }
             } else {
            	println "Updating backend file"
            	sh script: "sed -i -e 's/sol_name/"+solname+"/g' backend.tf"
			println "Executing Infrstructure build step" 
            	sh script: "/bin/rm -rf .terraform"
	        print  "sh script: ${tf_cmd} init -upgrade"
	        sh script: "${tf_cmd} init -upgrade"
            	count = sh(script: "grep vm_count main.tfvars | awk  '{print \$3}' |xargs", returnStdout: true)
            	//count = sh(script: "cat hosts.ini|wc -l", returnStdout: true)
           	 println count
            	println vm_count
            	def total_count = vm_count.toInteger() + count.toInteger()
            	println total_count
		sh script: "$tf_cmd apply -auto-approve -var-file=$path"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	 + " -var ansible_key=" + '${SSH_KEY}'	+	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'  +	" -var vm_count=" + total_count
            	sh script: "python3 ../../build-inventory.py " + solname
		echo "Inside Dir: ${pwd()}"
		println " ------${solname}----- "
            	sh script: "cat hosts.ini"
	   }
        }
        if (params.Install) {
	    println "Installing and conifguring the solution"
            println solname
            println "------------------"
            if (solname == 'MSSQLDC_Test') {
		println "-----${solname}---"
                // sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" +  "common-win.yml"
                sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/mssqldc-install.yml -vvv"
		// Joining Windows to Domain	
                sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" +  "win-domain.yml -v"
            } 
	    if (solname == 'MSSQL_Test') {
		println "-----${solname}---"
                sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/mssql-install.yml -vvv"
		// Joining Windows to Domain	
                // sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" +  "win-domain.yml -v"
            } 
            if  (solname == 'Oracle') {
                sh script: "cd /root/COPY_OF_ORACLE_BUILD/ansible; export ANSIBLE_COLLECTIONS_PATHS=/root/.ansible/collections; export ANSIBLE_ROLES_PATH=/root/.ansible/collections/ansible_collections/opitzconsulting/ansible_oracle/roles; export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.6; ansible-playbook -i inventory-asm-demo -e hostgroup=dbfs playbooks/single-instance-asm.yml --private-key "  + '${SSH_KEY}' + " --user ansible  -v"
            }
	    if  (solname == 'Oracle-demo') {
                //sh script: "cd /root/racsetup_copy/ansible; export ANSIBLE_COLLECTIONS_PATHS=/root/.ansible/collections; export ANSIBLE_ROLES_PATH=/root/.ansible/collections/ansible_collections/opitzconsulting/ansible_oracle/roles; export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.6; ansible-playbook -i inventory-rac -e hostgroup=dbfs playbooks/rac_iscsi_setup.yml --private-key "  + '${SSH_KEY}' + " --user ansible  -v"
		//sh script: "cd  /root/racsetup_copy/ansible; export ANSIBLE_COLLECTIONS_PATHS=/root/.ansible/collections; export ANSIBLE_ROLES_PATH=/root/.ansible/collections/ansible_collections/opitzconsulting/ansible_oracle/roles; export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.6;    ansible-playbook -i inventory-rac -e hostgroup=dbfs playbooks/ntp_server.yml --private-key "  + '${SSH_KEY}' + " --user ansible  -v"
	        sh script: "cd  /root/racsetup_copy/ansible; export ANSIBLE_COLLECTIONS_PATHS=/root/.ansible/collections; export ANSIBLE_ROLES_PATH=/root/.ansible/collections/ansible_collections/opitzconsulting/ansible_oracle/roles; export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.6; ansible-playbook -i inventory-rac -e hostgroup=dbfs playbooks/racattackl-install.yml --private-key "  + '${SSH_KEY}' + " --user ansible  -v"
	     }
            if  (solname == 'Veeam') {
		dir("${VEEAM_SERV_WSDIR}") {
                  def vpath = workspace + "/" + "modules" + "/" + "veeam-server".trim()
		  println "vpath ------${vpath}-----"
		  println "Windows_Admin_Pass ------${WINDOWS_ADMIN_PASS}-----"
		  /**
 		  * Install Veeam Ansible Collection
		  */
                  sh script: "ansible-galaxy collection install veeamhub.veeam"
		  // ISCSI MAPPINGS AND MULTIPATH ENABLED FOR THE LINUX SERVERS
		  sh script: "cd /vijayveeam/racsetup_copy/ansible; export ANSIBLE_COLLECTIONS_PATHS=/root/.ansible/collections; export ANSIBLE_ROLES_PATH=/root/.ansible/collections/ansible_collections/opitzconsulting/ansible_oracle/roles; export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.6; ansible-playbook -i veeam-asm -e hostgroup=dbfs  playbooks/veeam_iscsi_setup.yml  --private-key "  + '${SSH_KEY}' + " --user ansible  -v"	
		  // Joining FA to Domain	
                  //sh script: "ansible-playbook -i inventory.ini ../../ansible/playbooks/" +  "veeam-fa-domain.yml"

		  // Creating FS and Exports on FA 	
                  //sh script: "ansible-playbook -i inventory.ini ../../ansible/playbooks/" +  "veeam-fa-nfs-export.yml"

		  // Joining Windows to Domain	
                  sh script: "ansible-playbook -i inventory.ini ../../ansible/playbooks/" +  "veeam-win-domain.yml" + " -e 'ansible_user=Administrator ansible_password=${WINDOWS_ADMIN_PASS} ansible_connection=winrm ansible_shell_type=cmd ansible_port=5985 ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore ansible_winrm_scheme=http ansible_winrm_kerberos_delegation=true'"
			
		  // Install Veeam setup 
                  sh script: "cat ${VEEAM_SERV_WSDIR}/hosts.ini" 
               	  sh script: "echo [veeam-server] > inventory.ini"
               	  sh script: 'echo "veeam-server ansible_host=`head -n 1 ${VEEAM_SERV_WSDIR}/hosts.ini | tail -n 1 `" >> inventory.ini'
                  sh script: "cat inventory.ini"
		
               	  sh script: "ansible-playbook -i inventory.ini ../../ansible/playbooks/" +  "veeam-install.yml" + " -e 'ansible_user=Administrator ansible_password=${WINDOWS_ADMIN_PASS} ansible_connection=winrm ansible_shell_type=cmd ansible_port=5985 ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore ansible_winrm_scheme=http ansible_winrm_kerberos_delegation=true'" 

		

                 // Veeam Windows Proxy Server
                  sh script: "cat ${VEEAM_WINSERVS_WSDIR}/hosts.ini" 
               	  sh script: "echo [veeam-windows-proxy-server] >> inventory.ini"
               	  sh script: 'echo "windows_proxy_server ansible_host=`head -n 1 ${VEEAM_WINSERVS_WSDIR}/hosts.ini | tail -n 1 `" >> inventory.ini'
                  sh script: "cat inventory.ini"
               	  sh script: "ansible-playbook -i inventory.ini ../../ansible/playbooks/" +  "veeam-windows-proxy-server.yml" + " -e 'ansible_user=Administrator ansible_password=${WINDOWS_ADMIN_PASS} ansible_connection=winrm ansible_shell_type=cmd ansible_port=5985 ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore ansible_winrm_scheme=http ansible_winrm_kerberos_delegation=true'" 


		 // Window Repo Server
               	  sh script: "echo [veeam-windows-repo-server] >> inventory.ini"
               	  sh script: 'echo "windows_repo_server ansible_host=`head -n 2 ${VEEAM_WINSERVS_WSDIR}/hosts.ini | tail -n 1 `" >> inventory.ini'
                  sh script: "cat inventory.ini"
               	  sh script: "ansible-playbook -i inventory.ini ../../ansible/playbooks/" +  "veeam-windows-repo-server-add.yml" + " -e 'ansible_user=Administrator ansible_password=${WINDOWS_ADMIN_PASS} ansible_connection=winrm ansible_shell_type=cmd ansible_port=5985 ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore ansible_winrm_scheme=http ansible_winrm_kerberos_delegation=true'" 
			
                  // Linux Repo Server
                  sh script: "cat ${VEEAM_LINSERVS_WSDIR}/hosts.ini" 
               	  sh script: "echo [veeam-linux-repo-server] >> inventory.ini"
               	  sh script: 'echo -n "linux_repo_server ansible_host=`head -n 1 ${VEEAM_LINSERVS_WSDIR}/hosts.ini | tail -n 1 `" >> inventory.ini'
                  sh script: "cat inventory.ini"
               	  sh script: "ansible-playbook -i inventory.ini ../../ansible/playbooks/" +  "veeam-linux-repo-server-add.yml" + " -e 'ansible_user=Administrator ansible_password=${WINDOWS_ADMIN_PASS} ansible_connection=winrm ansible_shell_type=cmd ansible_port=5985 ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore ansible_winrm_scheme=http ansible_winrm_kerberos_delegation=true'" 
			
		  // Add NFS Share 
               	  sh script: "ansible-playbook -i inventory.ini ../../ansible/playbooks/" +  "veeam-nfs-share.yml" + " -e 'ansible_user=Administrator ansible_password=${WINDOWS_ADMIN_PASS} ansible_connection=winrm ansible_shell_type=cmd ansible_port=5985 ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore ansible_winrm_scheme=http ansible_winrm_kerberos_delegation=true'" 

              }
            }
            else {
            //    sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" +  "common.yml --private-key "  + '${SSH_KEY}' + " --user ansible"
            //    sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" + solname.toLowerCase() + "-install.yml --private-key "  + '${SSH_KEY}' + " --user ansible"
            }
                
           
			
        }
        if (params.Test) {
          	println "Executing Performance step"
		
		if (solname == 'MSSQLDC_Test') {
		println "-----${solname}---"
                sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/mssqldc-test.yml -vvv"
            	} 
		else if (solname == 'MSSQL_Test') {
		println "-----${solname}---"
                sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/mssql-test.yml -vvv"
            	} 
          	else if  (solname == 'Veeam') {
			dir("${VEEAM_SERV_WSDIR}") {
		          echo "current working directory: ${pwd()}"
                          sh script: "cat ${VEEAM_SERV_WSDIR}/hosts.ini" 
               	          sh script: "echo [veeam-server] > inventory.ini"
               	          sh script: 'echo "veeam-server ansible_host=`head -n 1 ${VEEAM_SERV_WSDIR}/hosts.ini | tail -n 1 `" >> inventory.ini'

                 	 // Veeam Windows Proxy Server
                         sh script: "cat ${VEEAM_WINSERVS_WSDIR}/hosts.ini" 
               	         sh script: "echo [veeam-windows-proxy-server] >> inventory.ini"
               	         sh script: 'echo "windows_proxy_server ansible_host=`head -n 1 ${VEEAM_WINSERVS_WSDIR}/hosts.ini | tail -n 1 `" >> inventory.ini'
 
               	         sh script: "echo [veeam-windows-repo-server] >> inventory.ini"
               	         sh script: 'echo "windows_repo_server ansible_host=`head -n 2 ${VEEAM_WINSERVS_WSDIR}/hosts.ini | tail -n 1 `" >> inventory.ini'
 
                         sh script: "cat ${VEEAM_LINSERVS_WSDIR}/hosts.ini" 
                 	 sh script: "echo [veeam-linux-repo-server] >> inventory.ini"
               	         sh script: 'echo -n "linux_repo_server ansible_host=`head -n 1 ${VEEAM_LINSERVS_WSDIR}/hosts.ini | tail -n 1 `" >> inventory.ini'
                         sh script: "cat inventory.ini"
 
               	  	 sh script: "ansible-playbook -i inventory.ini ../../ansible/playbooks/" +  "veeam-nfs-share-backup-job.yml" + " -e 'ansible_user=Administrator ansible_password=${WINDOWS_ADMIN_PASS} ansible_connection=winrm ansible_shell_type=cmd ansible_port=5985 ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore ansible_winrm_scheme=http ansible_winrm_kerberos_delegation=true'"
			 sh script: "ansible-playbook -i inventory.ini ../../ansible/playbooks/" +  "veeam-nfs-restore.yml" + " -e 'ansible_user=Administrator ansible_password=${WINDOWS_ADMIN_PASS} ansible_connection=winrm ansible_shell_type=cmd ansible_port=5985 ansible_winrm_transport=ntlm ansible_winrm_server_cert_validation=ignore ansible_winrm_scheme=http ansible_winrm_kerberos_delegation=true'" 	
			}
		} else { 
	          sh script: "cd /root/racsetup_copy/ansible; export ANSIBLE_COLLECTIONS_PATHS=/root/.ansible/collections; export ANSIBLE_ROLES_PATH=/root/.ansible/collections/ansible_collections/opitzconsulting/ansible_oracle/roles; export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.6; ansible-playbook -i inventory-rac -e hostgroup=dbfs playbooks/does_tool_loadgen.yml --private-key "  + '${SSH_KEY}' + " --user ansible  -v"
	          // sh script: "cd /root/COPY_OF_ORACLE_BUILD/ansible; export ANSIBLE_COLLECTIONS_PATHS=/root/.ansible/collections; export ANSIBLE_ROLES_PATH=/root/.ansible/collections/ansible_collections/opitzconsulting/ansible_oracle/roles; export ANSIBLE_PYTHON_INTERPRETER=/usr/bin/python3.6; ansible-playbook -i inventory-asm-demo -e hostgroup=dbfs playbooks/does_tool_loadgen.yml --private-key "  + '${SSH_KEY}' + " --user ansible  -v"
                 // sh script: "ansible-playbook -i hosts.ini ../../ansible/playbooks/" + solname.toLowerCase() + "-test.yml --private-key "  + '${SSH_KEY}' + " --user ansible
              }
        }

        if (params.Destroy) {
	      if (solname == 'Veeam') {
		dir("${VEEAM_SERV_WSDIR}") {
                  println  "Destroying Veeam Setup"
                  def vpath = workspace + "/" + "modules" + "/" + "veeam-server".trim()
		  echo "current working directory: ${pwd()}"
		  println "vpath ------${vpath}-----"
	 	  println "Updating backend file"
            	  sh script: "sed -i -e 's/sol_name/"+"veem-server"+"/g' backend.tf"
                  sh script: "${tf_cmd} init -reconfigure"
	          sh script: "${tf_cmd} destroy -auto-approve -var-file=$vpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	+ " -var ansible_key=" + '${SSH_KEY}'	 +	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'	 +	" -var vm_count=" + '${vm_count}'	
               }

               	dir("${VEEAM_WINSERVS_WSDIR}") {
                  println  "Destroying Veeam Windows Servers"
                  def vpath = workspace + "/" + "modules" + "/" + "veeam-windows-servers".trim()
		  echo "current working directory: ${pwd()}"
		  println "vpath ------${vpath}-----"
	 	  println "Updating backend file"
            	  sh script: "sed -i -e 's/sol_name/"+"veeam-windows-servers"+"/g' backend.tf"
                  sh script: "${tf_cmd} init -reconfigure"
	          sh script: "${tf_cmd} destroy -auto-approve -var-file=$vpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	+ " -var ansible_key=" + '${SSH_KEY}'	 +	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'	 +	" -var vm_count=" + '${vm_count}'	
               }
               
               dir("${VEEAM_SERV_WSDIR}") {
                  println  "Destroying Veeam Setup"
                  def vpath = workspace + "/" + "modules" + "/" + "veeam-linux-servers".trim()
		  echo "current working directory: ${pwd()}"
		  println "vpath ------${vpath}-----"
	 	  println "Updating backend file"
            	  sh script: "sed -i -e 's/sol_name/"+"veem-linux-servers"+"/g' backend.tf"
                  sh script: "${tf_cmd} init -reconfigure"
	          sh script: "${tf_cmd} destroy -auto-approve -var-file=$vpath"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	+ " -var ansible_key=" + '${SSH_KEY}'	 +	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'	 +	" -var vm_count=" + '${vm_count}'	
               }
               


            } else {
                println "Executing Infrstructure destroy step" 
                sh script: "sed -i -e 's/sol_name/"+solname+"/g' backend.tf"
                sh script: "${tf_cmd} init -reconfigure"
			    sh script: "${tf_cmd} destroy -auto-approve -var-file=$path"  + "/main.tfvars" + " -var vsphere_password=" + '${VC_PASS}'	+ " -var ansible_key=" + '${SSH_KEY}'	 +	 " -var infoblox_pass=" + '${INFOBLOX_PASS}'	 +	" -var vm_count=" + '${vm_count}'	
            }
			
        }

	}
	
	
	
	
  }
      
