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

###
# High level options
###
default['chef_server']['api_version'] = "11.0.2"
default['chef_server']['flavor'] = "osc" # Open Source Chef

default['chef_server']['notification_email'] = "info@example.com"
default['chef_server']['bootstrap']['enable'] = true

####
# The Chef User that services run as
####
# The username for the chef services user
default['chef_server']['user']['username'] = "chef_server"
# The shell for the chef services user
default['chef_server']['user']['shell'] = "/bin/sh"
# The home directory for the chef services user
default['chef_server']['user']['home'] = "/opt/chef-server/embedded"

####
# RabbitMQ
####
default['chef_server']['rabbitmq']['enable'] = true
default['chef_server']['rabbitmq']['ha'] = false
default['chef_server']['rabbitmq']['dir'] = "/var/opt/chef-server/rabbitmq"
default['chef_server']['rabbitmq']['data_dir'] = "/var/opt/chef-server/rabbitmq/db"
default['chef_server']['rabbitmq']['log_directory'] = "/var/log/chef-server/rabbitmq"
default['chef_server']['rabbitmq']['vhost'] = '/chef'
default['chef_server']['rabbitmq']['user'] = 'chef'
default['chef_server']['rabbitmq']['password'] = 'chefrocks'
default['chef_server']['rabbitmq']['vhost1'] = '/sensu'
default['chef_server']['rabbitmq']['user1'] = 'sensu'
default['chef_server']['rabbitmq']['password1'] = 'Passw0rd'
default['chef_server']['rabbitmq']['vhost2'] = '/mcollective'
default['chef_server']['rabbitmq']['user2'] = 'mcollective'
default['chef_server']['rabbitmq']['password2'] = 'Passw0rd'
default['chef_server']['rabbitmq']['node_ip_address'] = '0.0.0.0'
default['chef_server']['rabbitmq']['node_port'] = '5672'
default['chef_server']['rabbitmq']['nodename'] = 'rabbit@localhost'
default['chef_server']['rabbitmq']['vip'] = '127.0.0.1'
default['chef_server']['rabbitmq']['consumer_id'] = 'hotsauce'

####
# Chef Solr
####
default['chef_server']['chef-solr']['enable'] = true
default['chef_server']['chef-solr']['ha'] = false
default['chef_server']['chef-solr']['dir'] = "/var/opt/chef-server/chef-solr"
default['chef_server']['chef-solr']['data_dir'] = "/var/opt/chef-server/chef-solr/data"
default['chef_server']['chef-solr']['log_directory'] = "/var/log/chef-server/chef-solr"
# defaults for heap size and new generation size are computed in the chef-solr
# recipe based on node memory
default['chef_server']['chef-solr']['heap_size'] = nil
default['chef_server']['chef-solr']['new_size'] = nil
default['chef_server']['chef-solr']['java_opts'] = ""
default['chef_server']['chef-solr']['ip_address'] = '127.0.0.1'
default['chef_server']['chef-solr']['vip'] = '127.0.0.1'
default['chef_server']['chef-solr']['port'] = 8983
default['chef_server']['chef-solr']['ram_buffer_size'] = 200
default['chef_server']['chef-solr']['merge_factor'] = 100
default['chef_server']['chef-solr']['max_merge_docs'] = 2147483647
default['chef_server']['chef-solr']['max_field_length'] = 100000
default['chef_server']['chef-solr']['max_commit_docs'] = 1000
default['chef_server']['chef-solr']['commit_interval'] = 60000 # in ms
default['chef_server']['chef-solr']['poll_seconds'] = 20 # slave -> master poll interval in seconds, max of 60 (see solrconfig.xml.erb)

####
# Chef Expander
####
default['chef_server']['chef-expander']['enable'] = true
default['chef_server']['chef-expander']['ha'] = false
default['chef_server']['chef-expander']['dir'] = "/var/opt/chef-server/chef-expander"
default['chef_server']['chef-expander']['log_directory'] = "/var/log/chef-server/chef-expander"
default['chef_server']['chef-expander']['reindexer_log_directory'] = "/var/log/chef-server/chef-expander-reindexer"
default['chef_server']['chef-expander']['consumer_id'] = "default"
default['chef_server']['chef-expander']['nodes'] = 2

####
# Bookshelf
####
default['chef_server']['bookshelf']['enable'] = true
default['chef_server']['bookshelf']['ha'] = false
default['chef_server']['bookshelf']['dir'] = "/var/opt/chef-server/bookshelf"
default['chef_server']['bookshelf']['data_dir'] = "/var/opt/chef-server/bookshelf/data"
default['chef_server']['bookshelf']['log_directory'] = "/var/log/chef-server/bookshelf"
default['chef_server']['bookshelf']['svlogd_size'] = 1000000
default['chef_server']['bookshelf']['svlogd_num'] = 10
default['chef_server']['bookshelf']['vip'] = node['fqdn']
default['chef_server']['bookshelf']['url'] = "https://#{node['fqdn']}"
default['chef_server']['bookshelf']['listen'] = '127.0.0.1'
default['chef_server']['bookshelf']['port'] = 4321
default['chef_server']['bookshelf']['stream_download'] = true
default['chef_server']['bookshelf']['access_key_id'] = "generated-by-default"
default['chef_server']['bookshelf']['secret_access_key'] = "generated-by-default"

####
# Erlang Chef Server API
####
default['chef_server']['erchef']['enable'] = true
default['chef_server']['erchef']['ha'] = false
default['chef_server']['erchef']['dir'] = "/var/opt/chef-server/erchef"
default['chef_server']['erchef']['log_directory'] = "/var/log/chef-server/erchef"
default['chef_server']['erchef']['svlogd_size'] = 1000000
default['chef_server']['erchef']['svlogd_num'] = 10
default['chef_server']['erchef']['vip'] = '127.0.0.1'
default['chef_server']['erchef']['listen'] = '127.0.0.1'
default['chef_server']['erchef']['port'] = 8000
default['chef_server']['erchef']['auth_skew'] = '900'
default['chef_server']['erchef']['bulk_fetch_batch_size'] = '5'
default['chef_server']['erchef']['max_cache_size'] = '10000'
default['chef_server']['erchef']['cache_ttl'] = '3600'
default['chef_server']['erchef']['db_pool_size'] = '20'
default['chef_server']['erchef']['ibrowse_max_sessions'] = 256
default['chef_server']['erchef']['ibrowse_max_pipeline_size'] = 1
default['chef_server']['erchef']['s3_bucket'] = 'bookshelf'
default['chef_server']['erchef']['s3_url_ttl'] = 900
default['chef_server']['erchef']['s3_parallel_ops_timeout'] = 5000
default['chef_server']['erchef']['s3_parallel_ops_fanout'] = 20
default['chef_server']['erchef']['proxy_user'] = "pivotal"
default['chef_server']['erchef']['validation_client_name'] = "chef-validator"
default['chef_server']['erchef']['umask'] = "0022"
default['chef_server']['erchef']['web_ui_client_name'] = "chef-webui"
default['chef_server']['erchef']['root_metric_key'] = "chefAPI"

####
# Chef Server WebUI
####
default['chef_server']['chef-server-webui']['enable'] = true
default['chef_server']['chef-server-webui']['ha'] = false
default['chef_server']['chef-server-webui']['dir'] = "/var/opt/chef-server/chef-server-webui"
default['chef_server']['chef-server-webui']['log_directory'] = "/var/log/chef-server/chef-server-webui"
default['chef_server']['chef-server-webui']['environment'] = 'chefserver'
default['chef_server']['chef-server-webui']['listen'] = '127.0.0.1'
default['chef_server']['chef-server-webui']['vip'] = '127.0.0.1'
default['chef_server']['chef-server-webui']['port'] = 9462
default['chef_server']['chef-server-webui']['backlog'] = 1024
default['chef_server']['chef-server-webui']['tcp_nodelay'] = true
default['chef_server']['chef-server-webui']['worker_timeout'] = 3600
default['chef_server']['chef-server-webui']['umask'] = "0022"
default['chef_server']['chef-server-webui']['worker_processes'] = 2
default['chef_server']['chef-server-webui']['session_key'] = "_sandbox_session"
default['chef_server']['chef-server-webui']['cookie_domain'] = "all"
default['chef_server']['chef-server-webui']['cookie_secret'] = "47b3b8d95dea455baf32155e95d1e64e"
default['chef_server']['chef-server-webui']['web_ui_client_name'] = "chef-webui"
default['chef_server']['chef-server-webui']['web_ui_admin_user_name'] = "admin"
default['chef_server']['chef-server-webui']['web_ui_admin_default_password'] = "p@ssw0rd1"

####
# Chef Pedant
####
default['chef_server']['chef-pedant']['dir'] = "/var/opt/chef-server/chef-pedant"
default['chef_server']['chef-pedant']['log_directory'] = "/var/log/chef-server/chef-pedant"
default['chef_server']['chef-pedant']['log_http_requests'] = true

###
# Estatsd
###
default['chef_server']['estatsd']['enable'] = true
default['chef_server']['estatsd']['dir'] = "/var/opt/chef-server/estatsd"
default['chef_server']['estatsd']['log_directory'] = "/var/log/chef-server/estatsd"
default['chef_server']['estatsd']['vip'] = "127.0.0.1"
default['chef_server']['estatsd']['port'] = 9466

###
# Load Balancer
###
default['chef_server']['lb']['enable'] = true
default['chef_server']['lb']['vip'] = "127.0.0.1"
default['chef_server']['lb']['api_fqdn'] = node['fqdn']
default['chef_server']['lb']['web_ui_fqdn'] = node['fqdn']
default['chef_server']['lb']['cache_cookbook_files'] = false
default['chef_server']['lb']['debug'] = false
default['chef_server']['lb']['upstream']['erchef'] = [ "127.0.0.1" ]
default['chef_server']['lb']['upstream']['chef-server-webui'] = [ "127.0.0.1" ]
default['chef_server']['lb']['upstream']['bookshelf'] = [ "127.0.0.1" ]

####
# Nginx
####
default['chef_server']['nginx']['enable'] = true
default['chef_server']['nginx']['ha'] = false
default['chef_server']['nginx']['dir'] = "/var/opt/chef-server/nginx"
default['chef_server']['nginx']['log_directory'] = "/var/log/chef-server/nginx"
default['chef_server']['nginx']['ssl_port'] = 443
default['chef_server']['nginx']['enable_non_ssl'] = false
default['chef_server']['nginx']['non_ssl_port'] = 80
default['chef_server']['nginx']['server_name'] = node['fqdn']
default['chef_server']['nginx']['url'] = "https://#{node['fqdn']}"
# These options provide the current best security with TSLv1
#default['chef_server']['nginx']['ssl_protocols'] = "-ALL +TLSv1"
#default['chef_server']['nginx']['ssl_ciphers'] = "RC4:!MD5"
# This might be necessary for auditors that want no MEDIUM security ciphers and don't understand BEAST attacks
#default['chef_server']['nginx']['ssl_protocols'] = "-ALL +SSLv3 +TLSv1"
#default['chef_server']['nginx']['ssl_ciphers'] = "HIGH:!MEDIUM:!LOW:!ADH:!kEDH:!aNULL:!eNULL:!EXP:!SSLv2:!SEED:!CAMELLIA:!PSK"
# The following favors performance and compatibility, addresses BEAST, and should pass a PCI audit
default['chef_server']['nginx']['ssl_protocols'] = "SSLv3 TLSv1"
default['chef_server']['nginx']['ssl_ciphers'] = "RC4-SHA:RC4-MD5:RC4:RSA:HIGH:MEDIUM:!LOW:!kEDH:!aNULL:!ADH:!eNULL:!EXP:!SSLv2:!SEED:!CAMELLIA:!PSK"
default['chef_server']['nginx']['ssl_certificate'] = nil
default['chef_server']['nginx']['ssl_certificate_key'] = nil
default['chef_server']['nginx']['ssl_country_name'] = "US"
default['chef_server']['nginx']['ssl_state_name'] = "WA"
default['chef_server']['nginx']['ssl_locality_name'] = "Seattle"
default['chef_server']['nginx']['ssl_company_name'] = "YouCorp"
default['chef_server']['nginx']['ssl_organizational_unit_name'] = "Operations"
default['chef_server']['nginx']['ssl_email_address'] = "you@example.com"
default['chef_server']['nginx']['worker_processes'] = node['cpu']['total'].to_i
default['chef_server']['nginx']['worker_connections'] = 10240
default['chef_server']['nginx']['sendfile'] = 'on'
default['chef_server']['nginx']['tcp_nopush'] = 'on'
default['chef_server']['nginx']['tcp_nodelay'] = 'on'
default['chef_server']['nginx']['gzip'] = "on"
default['chef_server']['nginx']['gzip_http_version'] = "1.0"
default['chef_server']['nginx']['gzip_comp_level'] = "2"
default['chef_server']['nginx']['gzip_proxied'] = "any"
default['chef_server']['nginx']['gzip_types'] = [ "text/plain", "text/css", "application/x-javascript", "text/xml", "application/xml", "application/xml+rss", "text/javascript", "application/json" ]
default['chef_server']['nginx']['keepalive_timeout'] = 65
default['chef_server']['nginx']['client_max_body_size'] = '250m'
default['chef_server']['nginx']['cache_max_size'] = '5000m'

###
# PostgreSQL
###
default['chef_server']['postgresql']['enable'] = true
default['chef_server']['postgresql']['ha'] = false
default['chef_server']['postgresql']['dir'] = "/var/opt/chef-server/postgresql"
default['chef_server']['postgresql']['data_dir'] = "/var/opt/chef-server/postgresql/data"
default['chef_server']['postgresql']['log_directory'] = "/var/log/chef-server/postgresql"
default['chef_server']['postgresql']['svlogd_size'] = 1000000
default['chef_server']['postgresql']['svlogd_num'] = 10
default['chef_server']['postgresql']['username'] = "opscode-pgsql"
default['chef_server']['postgresql']['shell'] = "/bin/sh"
default['chef_server']['postgresql']['home'] = "/var/opt/chef-server/postgresql"
default['chef_server']['postgresql']['user_path'] = "/opt/chef-server/embedded/bin:/opt/chef-server/bin:$PATH"
default['chef_server']['postgresql']['sql_user'] = "opscode_chef"
default['chef_server']['postgresql']['sql_password'] = "snakepliskin"
default['chef_server']['postgresql']['sql_ro_user'] = "opscode_chef_ro"
default['chef_server']['postgresql']['sql_ro_password'] = "shmunzeltazzen"
default['chef_server']['postgresql']['vip'] = "127.0.0.1"
default['chef_server']['postgresql']['port'] = 5432
default['chef_server']['postgresql']['listen_address'] = 'localhost'
default['chef_server']['postgresql']['max_connections'] = 200
default['chef_server']['postgresql']['md5_auth_cidr_addresses'] = [ ]
default['chef_server']['postgresql']['trust_auth_cidr_addresses'] = [ '127.0.0.1/32', '::1/128' ]
default['chef_server']['postgresql']['shmmax'] = kernel['machine'] =~ /x86_64/ ? 17179869184 : 4294967295
default['chef_server']['postgresql']['shmall'] = kernel['machine'] =~ /x86_64/ ? 4194304 : 1048575

# Resolves CHEF-3889
if (node['memory']['total'].to_i / 4) > ((node['chef_server']['postgresql']['shmmax'].to_i / 1024) - 2097152)
  # guard against setting shared_buffers > shmmax on hosts with installed RAM > 64GB
  # use 2GB less than shmmax as the default for these large memory machines
  default['chef_server']['postgresql']['shared_buffers'] = "14336MB"
else
  default['chef_server']['postgresql']['shared_buffers'] = "#{(node['memory']['total'].to_i / 4) / (1024)}MB"
end

default['chef_server']['postgresql']['work_mem'] = "8MB"
default['chef_server']['postgresql']['effective_cache_size'] = "#{(node['memory']['total'].to_i / 2) / (1024)}MB"
default['chef_server']['postgresql']['checkpoint_segments'] = 10
default['chef_server']['postgresql']['checkpoint_timeout'] = "5min"
default['chef_server']['postgresql']['checkpoint_completion_target'] = 0.9
default['chef_server']['postgresql']['checkpoint_warning'] = "30s"

##############################################################
default['chef_server']['dntmon']['enable'] = true
# The username for the dntmon services user
default['chef_server']['user']['username1'] = "dntmon"
# The shell for the dntmon services user
default['chef_server']['user']['shell1'] = "/bin/sh"
# The home directory for the dntmon services user
default['chef_server']['user']['home1'] = "/opt/chef-server/embedded"

####
# Redis
####
default['chef_server']['redis']['enable'] = true
default['chef_server']['redis']['ha'] = false
default['chef_server']['redis']['dir'] = "/var/opt/chef-server/redis"
default['chef_server']['redis']['pidfile'] = "/var/opt/chef-server/redis/redis.pid"
default['chef_server']['redis']['port'] = "6379"
default['chef_server']['redis']['addr'] = "0.0.0.0"
default['chef_server']['redis']['timeout'] = "300"
default['chef_server']['redis']['saves'] = [["900", "1"], ["300", "10"], ["60", "10000"]]
default['chef_server']['redis']['db_basename'] = "dump.rdb"
default['chef_server']['redis']['log_directory'] = "/var/log/dntmon/redis"

####
# Sensu
####
default['chef_server']['sensu']['enable'] = true
default['chef_server']['sensu']['ha'] = false
default['chef_server']['sensu']['log_directory'] = "/var/log/dntmon/sensu"
default['chef_server']['sensu']['server_log'] = "/var/log/dntmon/sensu_server"
default['chef_server']['sensu']['client_log'] = "/var/log/dntmon/sensu_client"
default['chef_server']['sensu']['dashboard_log'] = "/var/log/dntmon/sensu_dashboard"
default['chef_server']['sensu']['api_log'] = "/var/log/dntmon/sensu_api"

####
# Mongodb
####
default['chef_server']['mongodb']['enable'] = true
default['chef_server']['mongodb']['ha'] = false
default['chef_server']['mongodb']['dir'] = "/var/opt/chef-server/mongodb"
default['chef_server']['mongodb']['port'] = "27017"
default['chef_server']['mongodb']['addr'] = "127.0.0.1"
default['chef_server']['mongodb']['log_directory'] = "/var/log/dntmon/mongodb"

####
# Elasticsearch
####
default['chef_server']['elasticsearch']['enable'] = true
default['chef_server']['elasticsearch']['ha'] = false
default['chef_server']['elasticsearch']['dir'] = "/var/opt/chef-server/elasticsearch"
default['chef_server']['elasticsearch']['addr'] = "127.0.0.1"
default['chef_server']['elasticsearch']['clustername'] = "dntmon"
default['chef_server']['elasticsearch']['nodename'] = "mon01"
default['chef_server']['elasticsearch']['master'] = true
default['chef_server']['elasticsearch']['max_local'] = "1"
default['chef_server']['elasticsearch']['nshards'] = "4"
default['chef_server']['elasticsearch']['nreplicas'] = "0"
default['chef_server']['elasticsearch']['data_dir'] = "/var/opt/chef-server/elasticsearch/data"
default['chef_server']['elasticsearch']['work_dir'] = "/var/opt/chef-server/elasticsearch/work"
default['chef_server']['elasticsearch']['plugin_dir'] = "/var/opt/chef-server/elasticsearch/plugins"
default['chef_server']['elasticsearch']['memory'] = "512m"
default['chef_server']['elasticsearch']['stack_size'] = "512k"
default['chef_server']['elasticsearch']['jmx'] = false
default['chef_server']['elasticsearch']['rmi_addr'] = "127.0.0.1"
default['chef_server']['elasticsearch']['log_directory'] = "/var/log/dntmon/elasticsearch"

####
# Logstash
####
default['chef_server']['logstash']['enable'] = true
default['chef_server']['logstash']['ha'] = false
default['chef_server']['logstash']['dir'] = "/var/opt/chef-server/logstash"
default['chef_server']['logstash']['xms'] = "128m"
default['chef_server']['logstash']['xmx'] = "128m"
default['chef_server']['logstash']['enable_embedded_es'] = true
default['chef_server']['logstash']['inputs'] = []
default['chef_server']['logstash']['filters'] = []
default['chef_server']['logstash']['outputs'] = []
default['chef_server']['logstash']['log_directory'] = "/var/log/dntmon/logstash"

####
# Graylog2
####
default['chef_server']['graylog2']['enable'] = true
default['chef_server']['graylog2']['ha'] = false
default['chef_server']['graylog2']['dir'] = "/var/opt/chef-server/graylog2"
default['chef_server']['graylog2']['xms'] = "128m"
default['chef_server']['graylog2']['xmx'] = "128m"
default['chef_server']['graylog2']['nodename'] = "graylog1"
default['chef_server']['graylog2']['log_directory'] = "/var/log/dntmon/graylog2"


####
# Graylog2-webui
####
default['chef_server']['graylog2-webui']['enable'] = true
default['chef_server']['graylog2-webui']['ha'] = false
default['chef_server']['graylog2-webui']['dir'] = "/var/opt/chef-server/graylog2"
default['chef_server']['graylog2-webui']['nodename'] = "graylog1"
default['chef_server']['graylog2-webui']['log_directory'] = "/var/log/dntmon/graylog2-webui"
default['chef_server']['graylog2-webui']['listen'] = '0.0.0.0'
default['chef_server']['graylog2-webui']['vip'] = '127.0.0.1'
default['chef_server']['graylog2-webui']['port'] = 9662
default['chef_server']['graylog2-webui']['backlog'] = 1024
default['chef_server']['graylog2-webui']['tcp_nodelay'] = true
default['chef_server']['graylog2-webui']['worker_timeout'] = 3600
default['chef_server']['graylog2-webui']['umask'] = "0022"
default['chef_server']['graylog2-webui']['worker_processes'] = 2
default['chef_server']['graylog2-webui']['environment'] = 'production'

####
# Mcollective
####
default['chef_server']['mcollective']['enable'] = true
default['chef_server']['mcollective']['ha'] = false
default['chef_server']['mcollective']['dir'] = "/var/opt/chef-server/mcollective"
default['chef_server']['mcollective']['log_directory'] = "/var/log/dntmon/mcollective"

####
# Gdash
####
default['chef_server']['gdash']['enable'] = true
default['chef_server']['gdash']['ha'] = false
default['chef_server']['gdash']['dir'] = "/var/opt/chef-server/gdash"
default['chef_server']['gdash']['log_directory'] = "/var/log/dntmon/gdash"
default['chef_server']['gdash']['listen'] = '0.0.0.0'
default['chef_server']['gdash']['vip'] = '127.0.0.1'
default['chef_server']['gdash']['port'] = 9393
default['chef_server']['gdash']['backlog'] = 1024
default['chef_server']['gdash']['tcp_nodelay'] = true
default['chef_server']['gdash']['worker_timeout'] = 3600
default['chef_server']['gdash']['umask'] = "0022"
default['chef_server']['gdash']['worker_processes'] = 2
default['chef_server']['gdash']['environment'] = 'production'

####
# Geminabox
####
default['chef_server']['geminabox']['enable'] = true
default['chef_server']['geminabox']['ha'] = false
default['chef_server']['geminabox']['dir'] = "/var/opt/chef-server/geminabox"
default['chef_server']['geminabox']['log_directory'] = "/var/log/dntmon/geminabox"
default['chef_server']['geminabox']['listen'] = '0.0.0.0'
default['chef_server']['geminabox']['vip'] = '127.0.0.1'
default['chef_server']['geminabox']['port'] = 9292
default['chef_server']['geminabox']['backlog'] = 1024
default['chef_server']['geminabox']['tcp_nodelay'] = true
default['chef_server']['geminabox']['worker_timeout'] = 3600
default['chef_server']['geminabox']['umask'] = "0022"
default['chef_server']['geminabox']['worker_processes'] = 1
default['chef_server']['geminabox']['environment'] = 'production'

####
# Infoboard
####
default['chef_server']['info-dashboard']['enable'] = true
default['chef_server']['info-dashboard']['ha'] = false
default['chef_server']['info-dashboard']['dir'] = "/var/opt/chef-server/info-dashboard"
default['chef_server']['info-dashboard']['log_directory'] = "/var/log/dntmon/info-dashboard"
default['chef_server']['info-dashboard']['listen'] = '0.0.0.0'
default['chef_server']['info-dashboard']['vip'] = '127.0.0.1'
default['chef_server']['info-dashboard']['port'] = 8010
default['chef_server']['info-dashboard']['backlog'] = 1024
default['chef_server']['info-dashboard']['tcp_nodelay'] = true
default['chef_server']['info-dashboard']['worker_timeout'] = 3600
default['chef_server']['info-dashboard']['umask'] = "0022"
default['chef_server']['info-dashboard']['worker_processes'] = 4
default['chef_server']['info-dashboard']['environment'] = 'production'

####
# Other
####
default['chef_server']['nginx']['sensu_dns']= "sensu.dntmon.com"
default['chef_server']['nginx']['gem_dns']= "gemserver"
default['chef_server']['nginx']['rabbitmq_dns']= "rabbitmq.dntmon.com"
default['chef_server']['nginx']['graylog2_dns']= "log.dntmon.com"
default['chef_server']['nginx']['graphite1_dns']= "graphite1.dntmon.com"
default['chef_server']['nginx']['graphite2_dns']= "graphite2.dntmon.com"
default['chef_server']['nginx']['gdash_dns']= "gdash.dntmon.com"
default['chef_server']['nginx']['infoboard_dns']= "infoboard.dntmon.com"


