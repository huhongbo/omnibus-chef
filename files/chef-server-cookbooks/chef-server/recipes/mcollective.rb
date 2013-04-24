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

mcollective_dir = node['chef_server']['mcollective']['dir']
mcollective_etc_dir = File.join(mcollective_dir, "etc")
mcollective_plugins_dir_symlink = File.join(mcollective_dir, "plugins")
mcollective_plugins_dir = "/opt/chef-server/embedded/service/mcollective/plugins"
mcollective_log_dir = node['chef_server']['mcollective']['log_directory']
[
  mcollective_dir,
  mcollective_etc_dir,
  mcollective_log_dir
].each do |dir_name|
  directory dir_name do
    owner node['chef_server']['user']['username1']
    mode '0700'
    recursive true
  end
end

directory "/opt/chef-server/embedded/service/mcollective" do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

link mcollective_plugins_dir_symlink do
  to mcollective_plugins_dir
  not_if { mcollective_plugins_dir == mcollective_plugins_dir_symlink }
end

mcollective_server_config = File.join(mcollective_etc_dir, "server.cfg")
mcollective_client_config = File.join(mcollective_etc_dir, "client.cfg")

template mcollective_server_config do
  source "server.cfg.erb"
  mode "644"
  variables(node['chef_server']['mcollective'].to_hash)
  notifies :restart, 'service[mcollective]' if OmnibusHelper.should_notify?("mcollective")
end

template mcollective_client_config do
  source "client.cfg.erb"
  mode "644"
  variables(node['chef_server']['mcollective'].to_hash)
  notifies :restart, 'service[mcollective]' if OmnibusHelper.should_notify?("mcollective")
end

runit_service "mcollective" do
  down node['chef_server']['mcollective']['ha']
  options({
    :log_directory => mcollective_log_dir,
  }.merge(params))
end

if node['chef_server']['bootstrap']['enable']
  execute "/opt/chef-server/bin/chef-server-ctl start mcollective" do
    retries 20
  end
end
