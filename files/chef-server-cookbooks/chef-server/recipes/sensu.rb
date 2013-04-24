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

directory "/etc/sensu" do
  owner "root"
  group "root"
  mode "0775"
  action :nothing
end.run_action(:create)

sensu_dir = "/etc/sensu"
sensu_conf_dir = File.join(sensu_dir, "conf.d")
sensu_extent_dir = File.join(sensu_dir, "extensions")
sensu_plugin_dir = File.join(sensu_dir, "plugins")
sensu_handler_dir = File.join(sensu_dir, "handlers")
sensu_log_dir = node['chef_server']['sensu']['log_directory']
sensu_server_log_dir = node['chef_server']['sensu']['server_log']
sensu_api_log_dir = node['chef_server']['sensu']['api_log']
sensu_client_log_dir = node['chef_server']['sensu']['client_log']
sensu_dashboard_log_dir = node['chef_server']['sensu']['dashboard_log']
[
  sensu_conf_dir,
  sensu_extent_dir,
  sensu_plugin_dir,
  sensu_handler_dir,
  sensu_log_dir,
  sensu_server_log_dir,
  sensu_api_log_dir,
  sensu_client_log_dir,
  sensu_dashboard_log_dir
].each do |dir_name|
  directory dir_name do
    owner node['chef_server']['user']['username1']
    mode '0700'
    recursive true
  end
end

sensu_config = File.join(sensu_dir, "config.json")
sensu_client_config = File.join(sensu_dir, "conf.d", "config.json")

template sensu_config do
  source "config.json.erb"
  mode "644"
  variables(node['chef_server']['sensu'].to_hash)
  notifies :restart, 'service[sensu-server]' if OmnibusHelper.should_notify?("sensu")
end

template sensu_client_config do
  source "client.json.erb"
  mode "644"
  variables(node['chef_server']['sensu'].to_hash)
  notifies :restart, 'service[sensu-client]' if OmnibusHelper.should_notify?("sensu")
end

[
  "sensu-server",
  "sensu-api",
  "sensu-client",
  "sensu-dashboard"
].each do |serv|
  runit_service serv do
   down node['chef_server']['sensu']['ha']
   options({
     :log_directory => sensu_log_dir,
   }.merge(params))
 end
end

[
  "sensu-server",
  "sensu-api",
  "sensu-client",
  "sensu-dashboard"
].each do |serv|
  if node['chef_server']['bootstrap']['enable']
   execute "/opt/chef-server/bin/chef-server-ctl start #{serv}" do
     retries 20
    end
  end
end
