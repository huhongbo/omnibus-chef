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

rabbitmq_dir = node['chef_server']['rabbitmq']['dir']
rabbitmq_etc_dir = File.join(rabbitmq_dir, "etc")
rabbitmq_data_dir = node['chef_server']['rabbitmq']['data_dir']
rabbitmq_data_dir_symlink = File.join(rabbitmq_dir, "db")
rabbitmq_log_dir = node['chef_server']['rabbitmq']['log_directory']

[ rabbitmq_dir, rabbitmq_etc_dir, rabbitmq_data_dir, rabbitmq_log_dir ].each do |dir_name|
  directory dir_name do
    owner node['chef_server']['user']['username']
    mode '0700'
    recursive true
  end
end

link rabbitmq_data_dir_symlink do
  to rabbitmq_data_dir
  not_if { rabbitmq_data_dir_symlink == rabbitmq_data_dir }
end

rabbitmq_service_dir = "/opt/chef-server/embedded/service/rabbitmq"

cookbook_file "/opt/chef-server/embedded/service/rabbitmq/sbin/rabbitmqadmin" do
  backup 1
  mode 0755
  source "rabbitmqadmin"
end

cookbook_file "/opt/chef-server/embedded/service/rabbitmq/sbin/rabbitmq-server" do
  backup 1
  mode 0755
  source "rabbitmq-server"
end

cookbook_file "/opt/chef-server/embedded/service/rabbitmq/sbin/rabbitmq-plugins" do
  backup 1
  mode 0755
  source "rabbitmq-plugins"
end
######################################################################
# NOTE:
# we do the symlinking in the build, but we're just making sure that
# the links are still there in the cookbook
######################################################################
%w[rabbitmqctl rabbitmq-env rabbitmq-multi rabbitmq-server rabbitmqadmin rabbitmq-plugins].each do |cmd|
  link "/opt/chef-server/embedded/bin/#{cmd}" do
    to File.join(rabbitmq_service_dir, "sbin", cmd)
  end
end

config_file = File.join(node['chef_server']['rabbitmq']['dir'], "etc", "rabbitmq.conf")

template "#{rabbitmq_service_dir}/sbin/rabbitmq-env" do
  owner "root"
  group "root"
  mode "0755"
  variables( :config_file => config_file )
  source "rabbitmq-env.erb"
end

template config_file do
  source "rabbitmq.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(node['chef_server']['rabbitmq'].to_hash)
end

runit_service "rabbitmq" do
  down node['chef_server']['rabbitmq']['ha']
  options({
    :log_directory => rabbitmq_log_dir
  }.merge(params))
end

if node['chef_server']['bootstrap']['enable']

  execute "/opt/chef-server/embedded/bin/rabbitmq-plugins enable rabbitmq_stomp rabbitmq_management" do
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmq-plugins list | grep -e \"\[E\] rabbitmq_management\" -e \"\[E\] rabbitmq_stomp\""
    user node['chef_server']['user']['username']
    retries 10
  end

  execute "/opt/chef-server/bin/chef-server-ctl restart rabbitmq" do
    retries 20
  end

  execute "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl wait /var/opt/chef-server/rabbitmq/db/rabbit@localhost.pid" do
    retries 10
  end

  execute "/opt/chef-server/embedded/bin/rabbitmqctl add_vhost #{node["chef_server"]["rabbitmq"]["vhost"]}" do
    user node['chef_server']['user']['username']
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_vhosts| grep #{node["chef_server"]["rabbitmq"]["vhost"]}"
    retries 20
  end

  execute "/opt/chef-server/embedded/bin/rabbitmqctl add_vhost #{node["chef_server"]["rabbitmq"]["vhost1"]}" do
    user node['chef_server']['user']['username']
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_vhosts| grep #{node["chef_server"]["rabbitmq"]["vhost1"]}"
    retries 20
  end

  execute "/opt/chef-server/embedded/bin/rabbitmqctl add_vhost #{node["chef_server"]["rabbitmq"]["vhost2"]}" do
    user node['chef_server']['user']['username']
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_vhosts| grep #{node["chef_server"]["rabbitmq"]["vhost2"]}"
    retries 20
  end


  execute "/opt/chef-server/embedded/bin/rabbitmqctl add_user #{node['chef_server']['rabbitmq']['user2']} #{node['chef_server']['rabbitmq']['password2']}" do
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_users |grep #{node['chef_server']['rabbitmq']['user2']}"
    user node['chef_server']['user']['username']
    retries 10
  end

  execute "/opt/chef-server/embedded/bin/rabbitmqctl set_user_tags #{node['chef_server']['rabbitmq']['user2']} administrator" do
    user node['chef_server']['user']['username']
    retries 10
  end

  # create chef user for the queue
  execute "/opt/chef-server/embedded/bin/rabbitmqctl add_user #{node['chef_server']['rabbitmq']['user']} #{node['chef_server']['rabbitmq']['password']}" do
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_users |grep #{node['chef_server']['rabbitmq']['user']}"
    user node['chef_server']['user']['username']
    retries 10
  end

  # create chef user for the queue
  execute "/opt/chef-server/embedded/bin/rabbitmqctl add_user #{node['chef_server']['rabbitmq']['user1']} #{node['chef_server']['rabbitmq']['password1']}" do
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_users |grep #{node['chef_server']['rabbitmq']['user1']}"
    user node['chef_server']['user']['username']
    retries 10
  end

  # grant the mapper user the ability to do anything with the /chef vhost
  # the three regex's map to config, write, read permissions respectively
  execute "/opt/chef-server/embedded/bin/rabbitmqctl set_permissions -p #{node['chef_server']['rabbitmq']['vhost']} #{node['chef_server']['rabbitmq']['user']} \".*\" \".*\" \".*\"" do
    user node['chef_server']['user']['username']
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_user_permissions #{node['chef_server']['rabbitmq']['user']}|grep #{node['chef_server']['rabbitmq']['vhost']}"
    retries 10
  end

  execute "/opt/chef-server/embedded/bin/rabbitmqctl set_permissions -p #{node['chef_server']['rabbitmq']['vhost2']} #{node['chef_server']['rabbitmq']['user2']} \".*\" \".*\" \".*\"" do
    user node['chef_server']['user']['username']
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_user_permissions #{node['chef_server']['rabbitmq']['user2']}|grep #{node['chef_server']['rabbitmq']['vhost2']}"
    retries 10
  end

  # grant the mapper user the ability to do anything with the /chef vhost
  # the three regex's map to config, write, read permissions respectively
  execute "/opt/chef-server/embedded/bin/rabbitmqctl set_permissions -p #{node['chef_server']['rabbitmq']['vhost1']} #{node['chef_server']['rabbitmq']['user1']} \".*\" \".*\" \".*\"" do
    user node['chef_server']['user']['username']
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_user_permissions #{node['chef_server']['rabbitmq']['user1']}|grep #{node['chef_server']['rabbitmq']['vhost1']}"
    retries 10
  end

  execute "/opt/chef-server/embedded/bin/rabbitmqadmin -V #{node['chef_server']['rabbitmq']['vhost2']} -u #{node['chef_server']['rabbitmq']['user2']} -p #{node['chef_server']['rabbitmq']['password2']} declare exchange name=mcollective_broadcast type=topic" do
    user node['chef_server']['user']['username']
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_exchanges -p #{node['chef_server']['rabbitmq']['vhost2']}|grep mcollective_broadcast"
    retries 10
  end

  execute "/opt/chef-server/embedded/bin/rabbitmqadmin -V #{node['chef_server']['rabbitmq']['vhost2']} -u #{node['chef_server']['rabbitmq']['user2']} -p #{node['chef_server']['rabbitmq']['password2']} declare exchange name=mcollective_directed type=direct" do
    user node['chef_server']['user']['username']
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_exchanges -p #{node['chef_server']['rabbitmq']['vhost2']}|grep mcollective_directed"
    retries 10
  end
end


