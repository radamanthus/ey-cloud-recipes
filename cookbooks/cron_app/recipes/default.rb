#
# Cookbook Name:: cron_app
# Recipe:: default
#

if ['solo', 'app_master', 'app'].include?(node[:instance_role])
  # Find all cron jobs specified in attributes/cron.rb
  crons = node[:app_crons]
  crons.each do |cron|
    cron cron[:name] do
      user     node['owner_name']
      action   :create
      minute   cron[:time].split[0]
      hour     cron[:time].split[1]
      day      cron[:time].split[2]
      month    cron[:time].split[3]
      weekday  cron[:time].split[4]
      command  cron[:command]
    end
  end
end
