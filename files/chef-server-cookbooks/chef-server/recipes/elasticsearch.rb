#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
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

elasticsearch_dir = node['chef_server']['elasticsearch']['dir']
elasticsearch_data_dir_symlink = "/opt/chef-server/embedded/service/elasticsearch/data"
elasticsearch_etc_dir = "/opt/chef-server/embedded/service/elasticsearch/config"
elasticsearch_plugin_dir = "/opt/chef-server/embedded/service/elasticsearch/plugins"
elasticsearch_bin_dir = "/opt/chef-server/embedded/service/elasticsearch/bin"
elasticsearch_etc_dir_symlink = File.join(elasticsearch_dir,"etc")
elasticsearch_plugin_dir_symlink = File.join(elasticsearch_dir,"plugins")
elasticsearch_log_dir = node['chef_server']['elasticsearch']['log_directory']
elasticsearch_data_dir = File.join(elasticsearch_dir, "data")
elasticsearch_work_dir = File.join(elasticsearch_dir, "work")
[
  elasticsearch_dir,
  elasticsearch_log_dir,
  elasticsearch_data_dir,
  elasticsearch_work_dir
].each do |dir_name|
  directory dir_name do
    owner node['chef_server']['user']['username1']
    mode '0700'
    recursive true
  end
end

directory "/opt/chef-server/embedded/service/elasticsearch" do
  owner 'dntmon'
  group 'root'
  mode '0755'
  recursive true
end

execute "chown -R dntmon:root /opt/chef-server/embedded/service/elasticsearch" do
  retries 20
end

link elasticsearch_data_dir_symlink do
  to elasticsearch_data_dir
  not_if { elasticsearch_data_dir == elasticsearch_data_dir_symlink }
end

link elasticsearch_etc_dir_symlink do
  to elasticsearch_etc_dir
  not_if { elasticsearch_etc_dir == elasticsearch_etc_dir_symlink }
end

link elasticsearch_plugin_dir_symlink do
  to elasticsearch_plugin_dir
  not_if { elasticsearch_plugin_dir == elasticsearch_plugin_dir_symlink }
end

elasticsearch_config = File.join(elasticsearch_etc_dir, "elasticsearch.yml")
elasticsearch_in = File.join(elasticsearch_bin_dir, "elasticsearch.in.sh")

template elasticsearch_config do
  source "elasticsearch.yml.erb"
  mode "644"
  variables(node['chef_server']['elasticsearch'].to_hash)
  notifies :restart, 'service[elasticsearch]' if OmnibusHelper.should_notify?("elsticsearch")
end

template elasticsearch_in do
  source "elasticsearch.in.sh.erb"
  mode "644"
  variables(node['chef_server']['elasticsearch'].to_hash)
  notifies :restart, 'service[elasticsearch]' if OmnibusHelper.should_notify?("elsticsearch")
end

runit_service "elasticsearch" do
  down node['chef_server']['elasticsearch']['ha']
  options({
    :log_directory => elasticsearch_log_dir,
  }.merge(params))
end

if node['chef_server']['bootstrap']['enable']
  execute "/opt/chef-server/bin/chef-server-ctl start elasticsearch" do
    retries 20
  end
end
