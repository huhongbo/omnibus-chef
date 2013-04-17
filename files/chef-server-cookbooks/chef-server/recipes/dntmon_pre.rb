user node['chef_server']['user']['username1'] do
  system true
  shell node['chef_server']['user']['shell1']
  home node['chef_server']['user']['home1']
end

group node['chef_server']['user']['username1'] do
  members [node['chef_server']['user']['username1']]
end
