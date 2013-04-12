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

# Create a user for Chef services to run as
user node['chef_server']['user']['username'] do
  system true
  shell node['chef_server']['user']['shell']
  home node['chef_server']['user']['home']
end

group node['chef_server']['user']['username'] do
  members [node['chef_server']['user']['username']]
end

user node['chef_server']['user']['username1'] do
  system true
  shell node['chef_server']['user']['shell1']
  home node['chef_server']['user']['home1']
end

group node['chef_server']['user']['username1'] do
  members [node['chef_server']['user']['username1']]
end
