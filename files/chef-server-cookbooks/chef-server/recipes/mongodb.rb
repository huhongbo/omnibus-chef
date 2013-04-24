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

mongodb_dir = node['chef_server']['mongodb']['dir']
mongodb_etc_dir = File.join(mongodb_dir, "etc")
mongodb_log_dir = node['chef_server']['mongodb']['log_directory']
mongodb_data_dir = File.join(mongodb_dir, "data")
[
  mongodb_dir,
  mongodb_etc_dir,
  mongodb_log_dir,
  mongodb_data_dir
].each do |dir_name|
  directory dir_name do
    owner node['chef_server']['user']['username1']
    mode '0700'
    recursive true
  end
end

directory "/opt/chef-server/embedded/service/mongodb" do
  owner "root"
  group "root"
  mode '0755'
  recursive true
end

mongodb_config = File.join(mongodb_etc_dir, "mongod.conf")

template mongodb_config do
  source "mongod.conf.erb"
  mode "644"
  variables(node['chef_server']['mongodb'].to_hash)
  notifies :restart, 'service[mongodb]' if OmnibusHelper.should_notify?("mongodb")
end

runit_service "mongodb" do
  down node['chef_server']['mongodb']['ha']
  options({
    :log_directory => mongodb_log_dir,
  }.merge(params))
end

if node['chef_server']['bootstrap']['enable']
  execute "/opt/chef-server/bin/chef-server-ctl start mongodb" do
    retries 20
  end
end
