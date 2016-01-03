# Tinyproxy Custom Chef Recipe for EYCloud

## Overview

In some cases third parties will allow only whitelisted IPs to connect to their services. This is usually the case with payment gateways, but may be applicable other cases as well.

Attaching EIPs to the instances that need to be whitelisted is an option but may not always be feasible if there are many instances need to connect and the third party has limited the whitelist to only a few IPs.

If you connect to the third party via HTTP then you can run tinyproxy on one instance (usually app_master, but can also be any util instance with an EIP), then proxy the HTTP requests through tinyproxy. This custom chef recipe will let you install tinyproxy on app_master. It can also be easily modified to run tinyproxy from a named utility instance instead.

## Installation

1. Add the following to your `main/recipes/default.rb`:

  ```
  include_recipe "redis"
  ```

2. Specify the application name and port by modifying lines 2-3 of `tinyproxy/recipes/default.rb`:

  ```
  app_name = "YOUR_APP_NAME_HERE"
  proxy_port = 8888
  ```

3. If you plan to run tinyproxy from a named utility instance, modify line 8 of `tinyproxy/recipes/default.rb` and specify the utility instance name:

  ```
  # Change the line below if you want to install tinyproxy on a util instance
  if node[:instance_role] == "app_master"
  ```

## Usage
