# Change app_name based on your application name
app_name = "web"
config_file = "/data/#{app_name}/shared/tinyproxy/tinyproxy.conf"
pid_file = "/data/#{app_name}/shared/tinyproxy/tinyproxy.pid"

# Change the line below if you want to install tinyproxy on a util instance
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
      :port => 8888
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
