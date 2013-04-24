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

geminabox_dir = node['chef_server']['geminabox']['dir']
geminabox_etc_dir = File.join(geminabox_dir, "etc")
geminabox_working_dir = File.join(geminabox_dir, "working")
geminabox_gem_dir = File.join(geminabox_dir, "gems")
geminabox_log_dir = node['chef_server']['geminabox']['log_directory']
[
  geminabox_dir,
  geminabox_etc_dir,
  geminabox_working_dir,
  geminabox_gem_dir,
  geminabox_log_dir
].each do |dir_name|
  directory dir_name do
    owner node['chef_server']['user']['username1']
    mode '0700'
    recursive true
  end
end

should_notify = OmnibusHelper.should_notify?("geminabox")
config_ru = File.join(geminabox_etc_dir, "config.ru")

cookbook_file config_ru do
  mode 0755
  source "config.ru"
end

unicorn_listen = node['chef_server']['geminabox']['listen']
unicorn_listen << ":#{node['chef_server']['geminabox']['port']}"

unicorn_config File.join(geminabox_etc_dir, "unicorn.rb") do
  listen unicorn_listen => {
    :backlog => node['chef_server']['geminabox']['backlog'],
    :tcp_nodelay => node['chef_server']['geminabox']['tcp_nodelay']
  }
  worker_timeout node['chef_server']['geminabox']['worker_timeout']
  working_directory geminabox_working_dir
  worker_processes node['chef_server']['geminabox']['worker_processes']
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[geminabox]' if should_notify
end

runit_service "geminabox" do
  down node['chef_server']['geminabox']['ha']
  options({
    :log_directory => geminabox_log_dir,
  }.merge(params))
end

if node['chef_server']['bootstrap']['enable']
  execute "/opt/chef-server/bin/chef-server-ctl start geminabox" do
    retries 20
  end
end
