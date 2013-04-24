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

graylog2_dir = node['chef_server']['graylog2']['dir']
graylog2_etc_dir = File.join(graylog2_dir, "etc")
graylog2_log_dir = node['chef_server']['graylog2']['log_directory']
[
  graylog2_dir,
  graylog2_etc_dir,
  graylog2_log_dir
].each do |dir_name|
  directory dir_name do
    owner node['chef_server']['user']['username1']
    mode '0700'
    recursive true
  end
end

directory "/opt/chef-server/embedded/service/graylog2" do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

graylog2_config = File.join(graylog2_etc_dir, "graylog2.conf")
graylog2_config1 = File.join(graylog2_etc_dir, "graylog2-elasticsearch.yml")

template graylog2_config do
  source "graylog2.conf.erb"
  mode "644"
  variables(node['chef_server']['graylog2'].to_hash)
  notifies :restart, 'service[graylog2]' if OmnibusHelper.should_notify?("graylog2")
end

template graylog2_config1 do
  source "graylog2-elasticsearch.yml.erb"
  mode "644"
  variables(node['chef_server']['graylog2'].to_hash)
  notifies :restart, 'service[graylog2]' if OmnibusHelper.should_notify?("graylog2")
end

runit_service "graylog2" do
  down node['chef_server']['graylog2']['ha']
  options({
    :log_directory => graylog2_log_dir,
  }.merge(params))
end

if node['chef_server']['bootstrap']['enable']
  execute "/opt/chef-server/bin/chef-server-ctl start graylog2" do
    retries 20
  end
end
