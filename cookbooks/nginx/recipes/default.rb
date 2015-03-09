file_owner = "deploy"
file_group = "deploy"

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :start, :enable ]
end

template "/data/nginx/nginx.conf" do
  owner file_owner
  group file_group
  mode 0644
  source "nginx.conf.erb"
  variables(
    :pool_size => 56,
    :user =>  file_owner
  )
  notifies :restart, 'service[nginx]', :delayed
end
