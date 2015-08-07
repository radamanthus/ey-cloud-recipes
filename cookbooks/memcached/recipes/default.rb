require 'pp'
#
# Cookbook Name:: memcached
# Recipe:: default
#

# Install memcached_custom.yml on app instances
memcached_instance = node['utility_instances'].find { |instance| instance['name'] == 'memcached' }

node[:applications].each do |app_name,data|
  user = node[:users].first

case node[:instance_role]
 when "solo", "app", "app_master"
   template "/data/#{app_name}/shared/config/memcached_custom.yml" do
     source "memcached.yml.erb"
     owner user[:username]
     group user[:username]
     mode 0744
     variables({
         :app_name => app_name,
         :server_names => [memcached_instance]
     })
   end
 end
end

# Install memcached and setup a monitrc file on the memcached utility instance
if ['util'].include?(node[:instance_role])
  if node[:name] == 'memcached'
   template "/etc/conf.d/memcached" do
     owner 'root'
     group 'root'
     mode 0644
     source "memcached.erb"
     variables :memusage => 64,
               :port     => 11211
   end

   template "/etc/monit.d/memcached.monitrc" do
     owner 'root'
     group 'root'
     mode 0644
     source "memcached.monitrc.erb"
     variables :pidfile => '/var/run/memcached/memcached-11211.pid'
   end
  end
end
