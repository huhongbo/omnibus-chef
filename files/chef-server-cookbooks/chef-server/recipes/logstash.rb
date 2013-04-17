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

logstash_dir = node['chef_server']['logstash']['dir']
logstash_etc_dir = File.join(logstash_dir, "etc")
logstash_tmp_dir = File.join(logstash_dir, "tmp")
logstash_patterns_dir = File.join(logstash_dir, "patterns")
logstash_log_dir = node['chef_server']['logstash']['log_directory']
logstash_data_dir = File.join(logstash_dir, "data")
[
  logstash_dir,
  logstash_etc_dir,
  logstash_log_dir,
  logstash_tmp_dir,
  logstash_patterns_dir,
  logstash_data_dir
].each do |dir_name|
  directory dir_name do
    owner node['chef_server']['user']['username1']
    mode '0700'
    recursive true
  end
end

logstash_config = File.join(logstash_etc_dir, "logstash.conf")

template logstash_config do
  source "logstash.conf.erb"
  mode "644"
  variables(node['chef_server']['logstash'].to_hash)
  notifies :restart, 'service[logstash]' if OmnibusHelper.should_notify?("logstash")
end

runit_service "logstash" do
  down node['chef_server']['logstash']['ha']
  options({
    :log_directory => logstash_log_dir,
  }.merge(params))
end

if node['chef_server']['bootstrap']['enable']
  execute "/opt/chef-server/bin/chef-server-ctl start logstash" do
    retries 20
  end
end
