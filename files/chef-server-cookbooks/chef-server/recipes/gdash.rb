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

gdash_gemfile = "/opt/chef-server/embedded/service/gdash/Gemfile"
gdash_dir = node['chef_server']['gdash']['dir']
gdash_etc_dir = File.join(gdash_dir, "etc")
gdash_working_dir = File.join(gdash_dir, "working")
gdash_log_dir = node['chef_server']['gdash']['log_directory']
[
  gdash_dir,
  gdash_etc_dir,
  gdash_working_dir,
  gdash_log_dir
].each do |dir_name|
  directory dir_name do
    owner node['chef_server']['user']['username1']
    mode '0700'
    recursive true
  end
end

execute "chown -R dntmon:root /opt/chef-server/embedded/service/gdash" do
  retries 20
end

should_notify = OmnibusHelper.should_notify?("gdash")
config_ru = File.join(gdash_etc_dir, "config.ru")

link config_ru do
  to "/opt/chef-server/embedded/service/gdash/config.ru"
end

unicorn_listen = node['chef_server']['gdash']['listen']
unicorn_listen << ":#{node['chef_server']['gdash']['port']}"

unicorn_config File.join(gdash_etc_dir, "unicorn.rb") do
  listen unicorn_listen => {
    :backlog => node['chef_server']['gdash']['backlog'],
    :tcp_nodelay => node['chef_server']['gdash']['tcp_nodelay']
  }
  worker_timeout node['chef_server']['gdash']['worker_timeout']
  working_directory gdash_working_dir
  worker_processes node['chef_server']['gdash']['worker_processes']
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[gdash]' if should_notify
end

execute "echo \"gem 'unicorn'\" >>#{gdash_gemfile}" do
  not_if gdash_gemfile.include?("unicorn")
  retries 10
end

template "/opt/chef-server/embedded/service/gdash/config/gdash.yaml" do
  source "gdash.yaml.erb"
  mode "644"
  notifies :restart, 'service[gdash]' if OmnibusHelper.should_notify?("gdash")
end

runit_service "gdash" do
  down node['chef_server']['gdash']['ha']
  options({
    :log_directory => gdash_log_dir,
  }.merge(params))
end

if node['chef_server']['bootstrap']['enable']
  execute "/opt/chef-server/bin/chef-server-ctl start gdash" do
    retries 20
  end
end
