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

graylog2_gemfile = "/opt/chef-server/embedded/service/graylog2-webui/Gemfile"
graylog2_webui_dir = node['chef_server']['graylog2-webui']['dir']
graylog2_webui_etc_dir = File.join(graylog2_webui_dir, "etc")
graylog2_webui_working_dir = File.join(graylog2_webui_dir, "working")
graylog2_webui_tmp_dir = File.join(graylog2_webui_dir, "tmp")
graylog2_webui_log_dir = node['chef_server']['graylog2-webui']['log_directory']
[
  graylog2_webui_dir,
  graylog2_webui_etc_dir,
  graylog2_webui_working_dir,
  graylog2_webui_tmp_dir,
  graylog2_webui_log_dir
].each do |dir_name|
  directory dir_name do
    owner node['chef_server']['user']['username1']
    mode '0700'
    recursive true
  end
end

directory "/opt/chef-server/embedded/service/graylog2-webui" do
  owner 'dntmon'
  group 'root'
  mode '0755'
  recursive true
end

execute "chown -R dntmon:root /opt/chef-server/embedded/service/graylog2-webui" do
  retries 20
end

should_notify = OmnibusHelper.should_notify?("graylog2-webui")
config_ru = File.join(graylog2_webui_etc_dir, "config.ru")

link config_ru do
  to "/opt/chef-server/embedded/service/graylog2-webui/config.ru"
end

unicorn_listen = node['chef_server']['graylog2-webui']['listen']
unicorn_listen << ":#{node['chef_server']['graylog2-webui']['port']}"

unicorn_config File.join(graylog2_webui_etc_dir, "unicorn.rb") do
  listen unicorn_listen => {
    :backlog => node['chef_server']['graylog2-webui']['backlog'],
    :tcp_nodelay => node['chef_server']['graylog2-webui']['tcp_nodelay']
  }
  worker_timeout node['chef_server']['graylog2-webui']['worker_timeout']
  working_directory graylog2_webui_working_dir
  worker_processes node['chef_server']['graylog2-webui']['worker_processes']
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[graylog2-webui]' if should_notify
end

link "/opt/chef-server/embedded/service/graylog2-webui/tmp" do
  to graylog2_webui_tmp_dir
end

execute "echo \"gem 'unicorn'\" >>#{graylog2_gemfile}" do
  not_if graylog2_gemfile.include?("unicorn")
  retries 10
end

execute "chown -R #{node['chef_server']['user']['username1']} /opt/chef-server/embedded/service/graylog2-webui/public"

runit_service "graylog2-webui" do
  down node['chef_server']['graylog2-webui']['ha']
  options({
    :log_directory => graylog2_webui_log_dir,
  }.merge(params))
end

if node['chef_server']['bootstrap']['enable']
  execute "/opt/chef-server/bin/chef-server-ctl start graylog2-webui" do
    retries 20
  end
end
