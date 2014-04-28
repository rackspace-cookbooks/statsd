#
# Cookbook Name:: rackspace_statsd
# Recipe:: default
#
# Copyright 2013 Rackspace, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an 'AS IS' BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.
#

include_recipe 'nodejs'
include_recipe 'runit'

package 'git' do
  action :install
  only_if { node['rackspace_statsd']['install_type'] == 'git' }
end

git '/opt/statsd' do
  repository 'https://github.com/etsy/statsd.git'
  revision node['rackspace_statsd']['git']['revision']
  user 'root'
  group 'root'
end

template '/opt/statsd/config.js' do
  cookbook node['rackspace_statsd']['templates']['config.js']
  source 'statsd-config.js.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(
              cookbook_name: cookbook_name
           )
end

runit_service 'statsd' do
  action [:enable, :start]
  service_name 'statsd'
  default_logger true
end
