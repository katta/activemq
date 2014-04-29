#
# Cookbook Name:: activemq
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'java::default'

tmp = Chef::Config[:file_cache_path]
version = node['activemq']['version']
mirror = node['activemq']['mirror']
activemq_home = "#{node['activemq']['home']}"

group "activemq" do
  gid node[:activemq][:gid]
  action :create
end

user "activemq" do
  uid node['activemq']['uid']
  gid node['activemq']['gid']
end

[node['activemq']['data_dir'], node['activemq']['log_dir'], node['activemq']['pid_dir'], node['activemq']['conf_dir']].each do |dir|
  directory dir do
    owner "activemq"
    group "activemq"
    recursive true
    mode 0755
  end
end

unless File.exists?("#{node['activemq']['home']}/bin/activemq")
  remote_file "#{tmp}/apache-activemq-#{version}-bin.tar.gz" do
    source "#{mirror}/activemq/apache-activemq/#{version}/apache-activemq-#{version}-bin.tar.gz"
    mode   '0644'
    owner   'activemq'
    group   'activemq'
  end

  execute "tar zxf #{tmp}/apache-activemq-#{version}-bin.tar.gz" do
    cwd node['activemq']['install_dir']
  end

  execute "chown -R activemq:activemq #{node['activemq']['install_dir']}/apache-activemq-#{version}" do
    cwd node['activemq']['install_dir']
  end

  link activemq_home do
    to "#{node['activemq']['install_dir']}/apache-activemq-#{version}"
    owner 'activemq'
    group 'activemq'
  end
end

template "/etc/init.d/activemq" do
  source   'activemq_initd.erb'
  mode     '0755'
  owner    'root'
  group    'root'
end

template "/etc/default/activemq" do
  source   'activemq_config.erb'
  mode     '0644'
  owner    'activemq'
  group    'activemq'
  notifies :restart, 'service[activemq]'
  variables({
    :activemq_home => activemq_home
  })
  only_if  { node['activemq']['use_default_config'] }
end

template "#{activemq_home}/conf/activemq.xml" do
  source   'activemq.xml.erb'
  mode     '0755'
  owner    'activemq'
  group    'activemq'
  notifies :restart, 'service[activemq]'
  only_if  { node['activemq']['use_default_config'] }
end

template "#{activemq_home}/conf/log4j.properties" do
  source   'log4j.properties.erb'
  mode     '0644'
  owner    'activemq'
  group    'activemq'
  notifies :restart, 'service[activemq]'
  only_if  { node['activemq']['use_default_config'] }
end

service 'activemq' do
  supports :restart => true, :status => true, :reload => true
  action   [:enable, :start]
end