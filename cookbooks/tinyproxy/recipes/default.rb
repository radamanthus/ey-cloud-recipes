# Change app_name based on your application name
app_name = "YOUR_APP_NAME_HERE"
proxy_port = 8888
tinyproxy_instance_name = 'tinyproxy'
config_file = "/data/#{app_name}/shared/tinyproxy/tinyproxy.conf"
pid_file = "/data/#{app_name}/shared/tinyproxy/tinyproxy.pid"

# Uncomment the two lines below if you want to install tinyproxy on a util instance
# tinyproxy_instance = node['utility_instances'].find { |instance| instance['name'] == tinyproxy_instance_name }
# if node[:instance_role] == 'util' && node[:engineyard][:environment][:name] == tinyproxy_instance_name

# Keep the line below if you plan to install tinyproxy on app_master, otherwise comment it out
if node[:instance_role] == "app_master"

  # Install the tinyproxy package
  package "net-proxy/tinyproxy" do
    version "1.8.3"
    action :install
  end

  # Create the tinyproxy directory
  directory "/data/#{app_name}/shared/tinyproxy" do
    owner 'deploy'
    group 'deploy'
    mode 0777
    recursive true
    action :create
  end

  # Create the tinyproxy config file
  template config_file do
    owner 'deploy'
    group 'deploy'
    mode 0644
    source 'tinyproxy.conf.erb'
    variables({
      :app_name => app_name,
      :port => proxy_port
    })
  end

  # Run tinyproxy from monit
  template '/data/monit.d/tinyproxy.monitrc' do
    owner 'root'
    group 'root'
    mode 0644
    source 'tinyproxy.monitrc.erb'
    variables({
      :pid_file => pid_file,
      :config_file => config_file
    })
  end

  execute "monit reload" do
    action :run
  end
end

# Write down the IP address and port used by the tinyproxy host
# so that web workers or background job workers know how to use tinyproxy
tinyproxy_host = get_instance_named(tinyproxy_instance_name)['private_hostname']
template "/data/#{app_name}/shared/config/tinyproxy.yml" do
  owner 'deploy'
  group 'deploy'
  mode 0644
  source 'tinyproxy.yml.erb'
  variables({
    :hostname => tinyproxy_host,
    :port => port
  })
end

