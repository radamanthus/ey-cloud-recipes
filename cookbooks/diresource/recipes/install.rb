# Copy diresource to /usr/local/bin
cookbook_file "/usr/local/bin/diresource" do
  source "diresource"
  backup 0
  owner "root"
  group "root"
  mode 0755
  action :create
end

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


