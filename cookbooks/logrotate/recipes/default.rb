#
# Cookbook Name:: logrotate
# Recipe:: default
#

remote_file "/etc/logrotate.d/daemon" do
  source "daemon.logrotate"
  owner "root"
  group "root"
  mode "0644"
  backup 0
end

cron "logrotate -f /etc/logrotate.d/daemon" do
  hour '0'
  minute  '0'
  command "logrotate -f /etc/logrotate.d/daemon"
  user "root"
end
