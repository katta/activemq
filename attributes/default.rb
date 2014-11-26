#
# Cookbook Name:: activemq
# Attributes:: default
#
# Copyright 2009-2011, Opscode, Inc.
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

default['activemq']['mirror']  = 'http://apache.mirrors.tds.net'
default['activemq']['version'] = '5.8.0'
default['activemq']['wrapper']['max_memory'] = '1024'
default['activemq']['wrapper']['useDedicatedTaskRunner'] = 'true'

default['activemq']['enable_stomp'] = true
default['activemq']['use_default_config'] = false

default['activemq']['uid']  = 61003
default['activemq']['gid']  = 61003
default['activemq']['install_dir']  = '/opt'
default['activemq']['home']  = node['activemq']['install_dir'] + "/activemq"
default['activemq']['data_base_dir'] = '/var/lib/activemq'
default['activemq']['data_dir'] = '/var/lib/activemq/data'
default['activemq']['log_dir'] = '/var/log/activemq'
default['activemq']['pid_dir'] = '/var/run/activemq'
default['activemq']['conf_dir'] = '/etc/activemq'

# Settings related to PersistenceAdapter and Cluster
default['activemq']['cluster'] = false
default['activemq']['cluster_name'] = 'localhost'

default['activemq']['persistence']['type'] = 'kahaDB' # [kahaDB|replicatedLevelDB]

default['activemq']['persistence']['replicas'] = '3'
default['activemq']['persistence']['bind_host'] = '0.0.0.0'
default['activemq']['persistence']['bind_port'] = '0'
default['activemq']['persistence']['hostname'] = Chef::Config[:node_name]

default['activemq']['persistence']['zookeeper']['path'] = '/activemq/leveldb-stores'
default['activemq']['persistence']['zookeeper']['servers'] = []

# Settings related to Broker Memory Configurations
default['activemq']['broker']['memoryUsage'] = '256' # Memory in MB
default['activemq']['broker']['storeUsage'] = '64'  # Memory in GB
default['activemq']['broker']['tempUsage'] = '16'  # Memory in GB
default['activemq']['memory']['flowControl'] = '1'  # Memory in MB