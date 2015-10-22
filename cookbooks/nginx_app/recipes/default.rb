file_owner = "deploy"
file_group = "deploy"

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :start, :enable ]
end

template "/data/nginx/servers/myapp.conf" do
  owner file_owner
  group file_group
  mode 0644
  source "myapp.conf.erb"
  variables(
    :app_name => 'myapp',
    :pool_size => 3,
    :user =>  file_owner
  )
  notifies :restart, 'service[nginx]', :delayed
end
