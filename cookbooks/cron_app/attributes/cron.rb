# Add one hash per cron job required
# Set the utility instance name to install each cron job on via instance_name

default[:app_crons] = [{:name => "test1", :time => "10 * * * *", :command => "echo 'test1'"},
                        {:name => "test2", :time => "10 1 * * *", :command => "echo 'test2'"}]
