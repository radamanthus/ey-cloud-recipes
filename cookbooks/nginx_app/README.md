Custom Nginx App Config Cookbook for Engine Yard Cloud
===================================

Overview
--------
This cookbook creates a custom Nginx app configuration in `/etc/nginx/servers/`.

Specifics of Usage
------------------

Modify `recipes/default.rb` and change all references to "myapp" into the actual name of your Engine Yard application.

Rename `myapp.conf.erb` (inside `templates/default`) to the actual name of your application. Keep the `conf.erb` extension.

Customize `templates/default/myapp.conf.erb` as you see fit. Take note that the `rack_env` setting in the line `rack_env production;
` should be consistent with what you specified for `Framework Environment` in the Engine Yard Cloud dashboard (https://support.cloud.engineyard.com/hc/en-us/articles/205407628-Set-Up-Your-Application-and-Environment).

On `templates/default/myapp.conf.erb`, change `listen 81;` to `listen 80;` if you're running a solo environment.
