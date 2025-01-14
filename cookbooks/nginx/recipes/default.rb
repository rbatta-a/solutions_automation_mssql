#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2024, The Authors, All Rights Reserved.
package 'nginx' do
  action :install
end

service 'nginx' do
  supports status: true, restart: true, reload: true
  action :enable
end

