#
# Cookbook:: veeam
# Recipe:: default
#
# maintainer:: Exosphere Data, LLC
# maintainer_email:: chef@exospheredata.com
#
# Copyright:: 2020, Exosphere Data, LLC, All Rights Reserved.
# A quick install of the backup service accepting the EULA and all of the defaults
#veeam_server 'Install Veeam Backup Server' do
#  version '12.0'
#  accept_eula true
#  package_url "http://13.238.131.132/VeeamDataPlatform_23H2_20240928.iso"
#  action :install
#end
#veeam_server 'Install Veeam Backup Server' do
#  version '9.0'
#  accept_eula true
#  action :install
#end
# Add a new VMware Proxy and register
veeam_proxy 'proxy01.demo.lab' do
  vbr_server      '10.21.210.117'
  vbr_username    'Administrator'
  vbr_password    'VMware1!'
  proxy_username  'administrator'
  proxy_password  'myextrapassword'
  proxy_type      'vmware'
  action :add
end
