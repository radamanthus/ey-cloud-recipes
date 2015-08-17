#
# Cookbook Name:: logrotate
# Recipe:: default
#

# logrotate config Nginx logs
remote_file "/etc/logrotate.d/nginx" do
  source "nginx.logrotate"
  owner "root"
  group "root"
  mode "0644"
  backup 0
end

# hourly cron entry for nginx logrotate
cron "logrotate -f /etc/logrotate.d/nginx" do
  minute  '0'
  command "logrotate -f /etc/logrotate.d/nginx"
  user "root"
end

# logrotate config for application logs
remote_file "/etc/logrotate.d/application-logs" do
  source "application-logs.logrotate"
  owner "root"
  group "root"
  mode "0644"
  backup 0
end

# hourly cron entry for application-logs logrotate
cron "logrotate -f /etc/logrotate.d/application-logs" do
  minute  '0'
  command "logrotate -f /etc/logrotate.d/application-logs"
  user "root"
end
