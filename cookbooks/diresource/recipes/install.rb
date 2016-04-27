# Copy diresource to /usr/local/bin
cookbook_file "/usr/local/bin/diresource" do
  source "diresource"
  backup 0
  owner "root"
  group "root"
  mode 0755
  action :create
end

# Create the nginx location block
execute "reload-nginx" do
  action :nothing
  command "/etc/init.d/nginx reload"
end

application = node[:diresource][:application]
template "/etc/nginx/servers/#{application}/additional_location_blocks.customer" do
  owner "deploy"
  group "deploy"
  mode 0644
  source "diresource.conf.erb"
  variables({
    :port => node[:diresource][:port]
  })
  notifies :run, resources(:execute => "reload-nginx")
end

# Configure diresource to start on boot
template "/etc/init.d/diresource" do
  owner "root"
  group "root"
  mode 0755
  source "diresource.erb"
  variables({
    :port => node[:diresource][:port]
  })
end

# This does not work on Gentoo 12.11. Maybe https://docs.chef.io/resource_service.html is not yet supported in Chef 10.6?
# Consider revisiting this in Gentoo 2016 stack which uses Chef 12
#service 'diresource' do
#  action :start
#end

execute "diresource_start_on_boot" do
  command "rc-update add diresource default"
end
