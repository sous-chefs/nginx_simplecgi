# nginx_simplecgi cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/nginx_simplecgi.svg)](https://supermarket.chef.io/cookbooks/nginx_simplecgi)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/nginx_simplecgi/master.svg)](https://circleci.com/gh/sous-chefs/nginx_simplecgi)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook provides CGI support for NGINX via SimpleCGI.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Debian/ Ubuntu
- RHEL based platforms (CentOS, Redhat, etc)

### Chef

- Chef 12.1+

### Cookbooks

- chef_nginx
- perl
- runit
- yum-epel

## Usage

### Attributes

- `node['nginx_simplecgi']['cgi'] -> Enable CGI dispatch`
- `node['nginx_simplecgi']['php'] -> Enable PHP dispatch`
- `node['nginx_simplecgi']['php_cgi_bin'] -> PHP executable path for CGI`
- `node['nginx_simplecgi']['init_type'] -> Init style for dispatchers`
- `node['nginx_simplecgi']['dispatcher_directory'] -> Directory to contain socket and pid files`
- `node['nginx_simplecgi']['dispatcher_processes'] -> Number of dispatcher processes for handling requests`

### Template Helper

A template method helper, `dispatch` is provided to add the require location block into your nginx configuration files:

```ruby
<%= nginx_dispatch(:cgi) %>
```

The default call will output:

```toml
  location ~ ^/cgi-bin/.*\.cgi$ {
    gzip off;
    fastcgi_pass  unix:/var/run/nginx/cgiwrap-dispatch.sock;
    fastcgi_index index.cgi;
    fastcgi_param SCRIPT_FILENAME /usr/lib$fastcgi_script_name;
    fastcgi_param QUERY_STRING     $query_string;
    fastcgi_param REQUEST_METHOD   $request_method;
    fastcgi_param CONTENT_TYPE     $content_type;
    fastcgi_param CONTENT_LENGTH   $content_length;
    fastcgi_param GATEWAY_INTERFACE  CGI/1.1;
    fastcgi_param SERVER_SOFTWARE    nginx;
    fastcgi_param SCRIPT_NAME        $fastcgi_script_name;
    fastcgi_param REQUEST_URI        $request_uri;
    fastcgi_param DOCUMENT_URI       $document_uri;
    fastcgi_param DOCUMENT_ROOT      $document_root;
    fastcgi_param SERVER_PROTOCOL    $server_protocol;
    fastcgi_param REMOTE_ADDR        $remote_addr;
    fastcgi_param REMOTE_PORT        $remote_port;
    fastcgi_param SERVER_ADDR        $server_addr;
    fastcgi_param SERVER_PORT        $server_port;
    fastcgi_param SERVER_NAME        $server_name;
  }
```

Available options:

- `:pattern -> change the pattern nginx matches`
- `:cgi_bin_dir -> change the prefix directory of the local cgi-bin`
- `:dispatcher -> use a custom dispatcher (socket or tcp based)`
- `:custom -> string to be appended within the location block`

The method will also accept a block that will be eval'd and the result appended within the location block.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
