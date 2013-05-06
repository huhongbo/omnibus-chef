rabbitmq_service_dir = "/opt/chef-server/embedded/service/rabbitmq"
nginx_dir = node['chef_server']['nginx']['dir']
nginx_etc_dir = File.join(nginx_dir, "etc")
nginx_files_dir = File.join(nginx_dir, "files")
nginx_config = File.join(nginx_etc_dir, "nginx.conf")
nginx_dntmon_conf = File.join(nginx_etc_dir, "dntmon.conf")
nginx_uwsgi = "/opt/chef-server/embedded/conf/uwsgi_params"
nginx_uwsgi_symlink = "/var/opt/chef-server/nginx/etc/uwsgi_params"

link nginx_uwsgi_symlink do
  to nginx_uwsgi
  not_if { nginx_uwsgi == nginx_uwsgi_symlink }
end

directory "/var/log/dntmon" do
  owner "root"
  group "root"
  mode "0775"
  action :nothing
end.run_action(:create)

directory nginx_files_dir do
    owner node['chef_server']['user']['username']
    mode '0700'
    recursive true
end

user node['chef_server']['user']['username1'] do
  system true
  shell node['chef_server']['user']['shell1']
  home node['chef_server']['user']['home1']
end

group node['chef_server']['user']['username1'] do
  members [node['chef_server']['user']['username1']]
end

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

%w[rabbitmqadmin rabbitmq-plugins].each do |cmd|
  link "/opt/chef-server/embedded/bin/#{cmd}" do
    to File.join(rabbitmq_service_dir, "sbin", cmd)
  end
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

  execute "/opt/chef-server/embedded/bin/rabbitmqctl add_user #{node['chef_server']['rabbitmq']['user1']} #{node['chef_server']['rabbitmq']['password1']}" do
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_users |grep #{node['chef_server']['rabbitmq']['user1']}"
    user node['chef_server']['user']['username']
    retries 10
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

  execute "/opt/chef-server/embedded/bin/rabbitmqctl set_user_tags #{node['chef_server']['rabbitmq']['user1']} administrator" do
    user node['chef_server']['user']['username']
    retries 10
  end

  execute "/opt/chef-server/embedded/bin/rabbitmqctl set_permissions -p #{node['chef_server']['rabbitmq']['vhost2']} #{node['chef_server']['rabbitmq']['user2']} \".*\" \".*\" \".*\"" do
    user node['chef_server']['user']['username']
    not_if "/opt/chef-server/embedded/bin/chpst -u #{node["chef_server"]["user"]["username"]} -U #{node["chef_server"]["user"]["username"]} /opt/chef-server/embedded/bin/rabbitmqctl list_user_permissions #{node['chef_server']['rabbitmq']['user2']}|grep #{node['chef_server']['rabbitmq']['vhost2']}"
    retries 10
  end

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

template nginx_dntmon_conf do
  source "dntmon.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[nginx]'
end
